# Forward only, no backing up and trying a different branch
struct Mul end
struct LeftParen end
struct RightParen end
struct Digit
  value::Int
end
struct Comma end

struct Do end
struct Dont end

struct Multiply
  vals::Array{Int}
end
struct Garbage end


Token = Union{Mul, LeftParen, RightParen, Digit, Comma, Garbage, Do, Dont}
Node = Union{Multiply}

struct Program
  instructions::Array{Node}
end

struct ParseContext
  current_idx::Int
  valid_tokens::Array{Token}
end
function parse_left_paren(input::String)
  if length(input) > 0 && input[1] === '('
    (LeftParen(), 1)
  else (Garbage(), 1)
  end
end

function parse_right_paren(input::String)
  if length(input) > 0 && input[1] === ')'
    (RightParen(), 1)
  else (Garbage(), 1)
  end
end

function parse_comma(input::String)
  if length(input) > 0 && input[1] === ','
    (Comma(), 1)
  else (Garbage(), 1)
  end
end

function parse_digits(input::String)
    
  function parse_digit(input::String)
    if length(input) > 0 && isdigit(input[1])
      input[1]
    else
      ""
    end
  end
  cur_digit = ""
  cur_input = input
  num_digits = 0
  while ((next_result = parse_digit(cur_input)) !== "")
    # show(next_result)
    cur_digit = string(cur_digit, next_result)
    cur_input = cur_input[2:length(cur_input)]
    num_digits += 1
  end

  if num_digits > 0
    (Digit(parse(Int, cur_digit)), num_digits)
  else 
    (Garbage(), 1)
  end
end

function parse_mul(input::String)
  if length(input) >= 3 && input[1:3] === "mul"
    (Mul(), 3)
  else (Garbage(), 1)
  end
end
function parse_do(input::String)
  if length(input) >= 4 && input[1:4] === "do()"
    (Do(), 4)
  else (Garbage(), 1)
  end
end
function parse_dont(input::String)
  if length(input) >= 7 && input[1:7] === "don't()"
    (Dont(), 7)
  else (Garbage(), 1)
  end
end

struct MulInstructionContext
  mul_seen::Bool
  left_paren_seen::Bool
  first_digit::Union{Bool, Digit}
  comma_seen::Bool
  second_digit::Union{Bool, Digit}
  right_paren_seen::Bool
end

function emic() 
  MulInstructionContext(false, false, false, false, false, false)
end

function get_next_mul_ctx(ctx::MulInstructionContext, next_token::Token)
  
  if !ctx.mul_seen
    if typeof(next_token) == Mul
      MulInstructionContext(
        true, false, false, false, false, false
      )
    else
      emic()
    end
  elseif !ctx.left_paren_seen
    if typeof(next_token) == LeftParen
      MulInstructionContext(
        true, true, false, false, false, false
      )
    else
      emic()
    end
  elseif typeof(ctx.first_digit) !== Digit
    if typeof(next_token) == Digit
      MulInstructionContext(
        true, true, next_token, false, false, false
      )
    else
      emic()
    end
  elseif !ctx.comma_seen
    if typeof(next_token) == Comma
      MulInstructionContext(
        true, true, ctx.first_digit, true, false, false
      )
    else
      emic()
    end
  elseif typeof(ctx.second_digit) !== Digit
    if typeof(next_token) == Digit
      MulInstructionContext(
        true, true, ctx.first_digit, true, next_token, false
      )
    else
      emic()
    end
  elseif !ctx.right_paren_seen
    if typeof(next_token) == RightParen
      MulInstructionContext(
        true, true, ctx.first_digit, true, ctx.second_digit, true
      )
    else
      emic()
    end
  else
    emic()
  end
end

struct ProgramParsingContext
  program::Program
  context::MulInstructionContext
  enabled::Bool
end

function (ctx::ProgramParsingContext)(next_token::Token)
  if typeof(next_token) === Do
    ProgramParsingContext(ctx.program, emic(), true)
  elseif typeof(next_token) === Dont
    ProgramParsingContext(ctx.program, emic(), false)
  else
    if ctx.enabled
        
      next_mul_ctx = get_next_mul_ctx(ctx.context, next_token)
      # println(next_mul_ctx)
      if next_mul_ctx.right_paren_seen
        # println("Wow!")
        valid_instruction = Multiply([next_mul_ctx.first_digit.value; next_mul_ctx.second_digit.value])
        # println(valid_instruction)
        
        ProgramParsingContext(
          Program([ctx.program.instructions;valid_instruction]),  
          emic(),
          ctx.enabled
        )
      else
        ProgramParsingContext(ctx.program, next_mul_ctx, ctx.enabled)
      end
    else
      ctx
    end
  end
  
end

function assemble(ctx::ParseContext):: Program 
  
  initial_ctx = ProgramParsingContext(Program([]), emic(), true)
  function f(acc::ProgramParsingContext, token::Token)
    # println(acc)
    acc(token)
  end
  final_ctx = foldl(f, ctx.valid_tokens; init=initial_ctx)
  
  # show(final_ctx)
  final_ctx.program
end


function run_parser(full_string::String)
  context = ParseContext(1, [])
  while(true)
    
    input = full_string[context.current_idx:length(full_string)]

    tokenizers = [
      parse_dont,
      parse_do,
      parse_left_paren,
      parse_right_paren,
      parse_comma,
      parse_mul,
      parse_digits
    ]
    if length(input) == 0
      break
    else
      # tokenizers[1](input)
      
      results::Vector{Tuple{Token, Int}} = map(f -> f(input), tokenizers)
      # show(results)
      first_matching_idx = findfirst(!=((Garbage(), 1)), results)

      if first_matching_idx !== nothing
        (matched, num_chars) = results[first_matching_idx]
        # println(matched)
        # println(num_chars)

        push!(context.valid_tokens, matched)
        new_idx = context.current_idx + num_chars
        context = ParseContext(new_idx, context.valid_tokens)
      else
        push!(context.valid_tokens, Garbage())
        new_idx = context.current_idx + 1
        context = ParseContext(new_idx, context.valid_tokens)
      end
    end
  end
  context
end

function run_multiply(m::Multiply) 
  reduce(*, m.vals;init=1)
end

function run_me() 
  input = open(io->read(io, String), "inputs/3.txt")
  # input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  context = run_parser(input)
  program = assemble(context)

  mapreduce(run_multiply, +, program.instructions)


end

println(run_me())
