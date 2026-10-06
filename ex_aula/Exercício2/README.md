# Exercício2
4-to-1 multiplexer with enable and high-Z output.
Entity: mux_4x1z
Inputs:
  i: 4-bit vector
  s: 2-bit select
  e: enable (active high)
Output: y (std_logic) -> selected input when e='1', else 'Z'
