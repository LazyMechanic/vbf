module main

import os

const (
	stack_size = int(30000)
)

const (
	flag_text = 'text'
	flag_text_a = 't'
)

const (
	next = `>`
	prev = `<`
	plus = `+`
	minus = `-`
	dot = `.`
	comma = `,`
	open = `[`
	close = `]`
)

fn main() {
	text := get_prg_text(os.args) or { panic('failed to get program text with error: $err') }
	start_interpreter(text) or { panic('interpretation failed with error: $err') }
}

fn start_interpreter(text string) ? {
	mut cur_index := int(0)
	mut i := int(0)
	mut state_i := int(0)
	mut arr := []byte{len: stack_size}
	mut state := []int{len: stack_size}
	for i < text.len {
		ch := text[i]
		match ch {
			next {
				cur_index++
				if cur_index >= stack_size {
					return error('out of memory (up)')
				}
			}
			prev {
				cur_index--
				if cur_index < 0 {
					return error('out of memory (down)')
				}
			}
			plus {
				arr[cur_index]++
			}
			minus {
				arr[cur_index]--
			}
			dot {
				print(arr[cur_index].str())
			}
			comma {
				v := os.get_line()
				arr[cur_index] = byte(v.i8())
			}
			open {
				if arr[cur_index] == 0 {
					for i < text.len {
						if text[i] == close {
							break
						}

						i++
					}
				} else {
					state[state_i] = i
					state_i++
				}
			}
			close {
				if state_i == 0 {
					return error('state is empty')
				}

				state_i--
				i = state[state_i]

				if i == 0 {
					continue
				} else {
					i--
				}
			}
			else { return error('unexpected char: $ch') }
		}

		i++
	}

	return none
}

fn get_prg_text(args []string) ?string {
	if args.len > 2 {
		return error('too much arguments, required 1 argument')
	}

	if args.len < 2 {
		return error('need to pass brainfuck program text in argument')
	}
	
	text := args[1]
	if text.len == 0 {
		return error('program text is empty')
	}

	return text
}