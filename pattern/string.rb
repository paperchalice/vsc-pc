require 'ruby_grammar_builder'

export = Grammar.new_exportable_grammar
# patterns that are imported
export.external_repos = [
  :line_continuation_character,
]

# patterns that are exported
export.exports = [
  :string_context,
  :variable_ref,
  :escape_char,
]

export[:escape_char] = Pattern.new(
  match: /\\['"?\\abfnrtv]/,
  tag_as: "constant.character.escape",
)

export[:string_context] = [
  PatternRange.new(
  tag_as: "string.quoted.double",
    start_pattern: Pattern.new(
      tag_as: "punctuation.definition.string.begin",
      match: /"/,
    ),
    end_pattern: Pattern.new(
      tag_as: "punctuation.definition.string.end",
      match: /"/,
    ),
    includes: [
      :escape_char,
      :variable_ref,
    ]
  ),
  PatternRange.new(
  tag_as: "string.quoted.single",
    start_pattern: Pattern.new(
      tag_as: "punctuation.definition.string.begin",
      match: /'/,
    ),
    end_pattern: Pattern.new(
      tag_as: "punctuation.definition.string.end",
      match: /'/,
    ),
    includes: [
      # normal escapes \r, \n, \t
      :escape_char,
    ]
  ),
]

export[:variable_ref] = PatternRange.new(
  tag_as: "variable.other.bracket",
  start_pattern: Pattern.new(
          match: lookBehindToAvoid("$").then(
            match: /\$/,
            tag_as: "punctuation.definition.variable punctuation.section.bracket.curly.variable.begin"
          ).then(
            match: /\{/,
            tag_as: "punctuation.section.bracket.curly.variable.begin",  
        )
      ),
    end_pattern: Pattern.new(
      match: /\}/,
      tag_as: "punctuation.section.bracket.curly.variable.end",
  )
)
