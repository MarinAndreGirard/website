-- Keep the author's normal image Markdown; use display copies only in the article.
local function escape(value)
  return tostring(value):gsub('&', '&amp;'):gsub('"', '&quot;'):gsub('<', '&lt;'):gsub('>', '&gt;')
end

function Pandoc(doc)
  if not quarto.doc.is_format('html') then return doc end
  local root = pandoc.path.normalize(quarto.project.directory)
  local file = assert(io.open(root .. '/assets/photo-previews/manifest.json', 'r'))
  local manifest = pandoc.json.decode(file:read('*a'))
  file:close()
  local inputDir = pandoc.path.directory(quarto.doc.input_file)
  if not pandoc.path.is_absolute(inputDir) then inputDir = pandoc.path.join({root, inputDir}) end
  local relativeDir = pandoc.path.make_relative(inputDir, root)
  local prefix = ''
  for part in relativeDir:gmatch('[^/]+') do
    if part ~= '.' then prefix = prefix .. '../' end
  end
  local first = true
  local function photo(image)
    local absolute = pandoc.path.normalize(pandoc.path.join({inputDir, image.src}))
    local key = pandoc.path.make_relative(absolute, root)
    local entry = manifest[key]
    if not entry then return nil end
    local sources = {}
    for _, variant in ipairs(entry.variants) do
      local relative = prefix .. variant.src
      sources[#sources + 1] = escape(relative) .. ' ' .. string.format('%d', variant.width) .. 'w'
    end
    local fallback = entry.variants[math.min(2, #entry.variants)]
    local fallbackSrc = prefix .. fallback.src
    local alt = image.attributes['fig-alt'] or pandoc.utils.stringify(image.caption)
    local loading = first and 'eager' or 'lazy'
    local priority = first and ' fetchpriority="high"' or ''
    first = false
    local html = string.format(
      '<a class="original-photo" href="%s" data-pswp-width="%d" data-pswp-height="%d" target="_blank" rel="noopener" aria-label="%s"><img src="%s" srcset="%s" sizes="(max-width: 767px) calc(100vw - 3rem), (max-width: 1200px) calc(100vw - 5rem), 1100px" width="%d" height="%d" alt="%s" loading="%s" decoding="async"%s></a>',
      escape(image.src), entry.width, entry.height, escape('Open full-resolution photo: ' .. alt),
      escape(fallbackSrc), table.concat(sources, ', '), entry.width, entry.height, escape(alt), loading, priority)
    local caption = pandoc.utils.stringify(image.caption)
    if caption ~= '' then html = html .. '<p class="photo-caption">' .. escape(caption) .. '</p>' end
    return pandoc.Div({pandoc.RawBlock('html', html)}, pandoc.Attr('', {'column-page', 'photo-frame'}))
  end
  -- Also separate a photo from preceding text when a blank line was omitted.
  return doc:walk({Para = function(paragraph)
    local blocks, text, changed = pandoc.List(), pandoc.List(), false
    local function flush()
      while #text > 0 and (text[#text].t == 'SoftBreak' or text[#text].t == 'Space') do text:remove(#text) end
      if #text > 0 then blocks:insert(pandoc.Para(text)); text = pandoc.List() end
    end
    for _, inline in ipairs(paragraph.content) do
      local rendered = inline.t == 'Image' and photo(inline) or nil
      if rendered then flush(); blocks:insert(rendered); changed = true
      elseif not (#text == 0 and (inline.t == 'SoftBreak' or inline.t == 'Space')) then text:insert(inline) end
    end
    if changed then flush(); return blocks end
  end})
end
