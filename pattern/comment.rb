require 'ruby_grammar_builder'

export = Grammar.new_exportable_grammar
# patterns that are imported
export.external_repos = [
  :line_continuation_character
]

# patterns that are exported
export.exports = [
  :line_comment,
  :comment,
]

export[:line_comment] = PatternRange.new(
  tag_as: "comment.line.number-sign",
  start_pattern: Pattern.new(/\s*+/).then(
    match: /#/,
    tag_as: "punctuation.definition.comment"
  ),
  # a newline that doesnt have a line continuation
  end_pattern: lookBehindFor(/\n/).lookBehindToAvoid(/\\\n/),
  includes: [ :line_continuation_character ]
)

export[:comment] = [
  :line_comment,
]
