-- Pandoc Filter to Generate FurAffinity Markup
-- By anonusr, 2022
--
-- Based on 2bbcode (https://github.com/lilydjwg/2bbcode)

-- Invoke with: pandoc -t to_furaffinity.lua [INPUTFILE]
--
-- Note that Pandoc has no concept of text color or alignment,
-- so these items will never be translated, even if FA supports them.


-- Blocksep is used to separate block elements.
function Blocksep()
  return "\n\n"
end

-- This function is called once for the whole document. Parameters:
-- body, title, date are strings; authors is an array of strings;
-- variables is a table.  One could use some kind of templating
-- system here; this just gives you a simple standalone HTML file.
function Doc(body, title, authors, date, variables)
  return body .. '\n'
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return s
end

function Space()
  return " "
end

function LineBreak()
  return "\n"
end

function Emph(s)
  return "[i]" .. s .. "[/i]"
end

function Strong(s)
  return "[b]" .. s .. "[/b]"
end

function Underline(s)
  return "[u]" .. s .. "[/u]"
end

function Subscript(s)
  return "[sub]" .. s .. "[/sub]"
end

function Superscript(s)
  return "[sup]" .. s .. "[/sup]"
end

function SmallCaps(s)
  error("SmallCaps isn't supported")
end

function Strikeout(s)
  return '[s]' .. s .. '[/s]'
end

function Link(s, src, tit)
  local ret = '[url'
  if s then
    ret = ret .. '=' .. src
  else
    s = src
  end
  ret = ret .. "]" .. s .. "[/url]"
  return ret
end

function Image(s, src, tit)
  error("Images aren't supported")
end

function Code(s, attr)
  error("Code isn't supported")
end

function InlineMath(s)
  error("InlineMath isn't supported")
end

function DisplayMath(s)
  error("DisplayMath isn't supported")
end

function Note(s)
  error("Note isn't supported")
end

function Plain(s)
  return s
end

function Para(s)
  return s
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
  return string.format("[h%d]%s[/h%d]",lev, s, lev)
end

function BlockQuote(s)
  return "[quote]\n" .. s .. "\n[/quote]"
end

function HorizontalRule()
  return "--------------------------------------------------------------------------------"
end

function Span(s, attr)
  return s
end

function Div(s, attr)
  return s .. '\n'
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function() return "" end
  end
setmetatable(_G, meta)
