; extends

; ```typst fences render through snacks.image's typst pipeline
; (same transform/converter it uses for math in .typ files)
(fenced_code_block
  (info_string (language) @lang)
  (#eq? @lang "typst")
  (code_fence_content) @image.content
  (#set! image.lang "typst")
  (#set! image.ext "math.typ")
) @image
