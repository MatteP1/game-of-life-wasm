(module
  (import "util" "random_cell" (func $get_random_cell (result i32 i32)))
  (memory 1)

  (global $universe_length i32 (i32.const 20))
  (global $universe_height i32 (i32.const 15))
  
  (global $test (mut i32) (i32.const 15))

  (func $get_universe_mem_size (result i32)
    global.get $universe_height
    global.get $universe_length
    i32.mul
    i32.const 4
    i32.mul
  )

  (func $get_universe_offset (result i32)
    i32.const 0
  )

  (func $get_new_universe_offset (result i32)
    call $get_universe_offset
    call $get_universe_mem_size
    i32.add
  )

  (func $get_cell_index (param $x i32) (param $y i32) (result i32)
    (local $x_universe i32)
    (local $y_universe i32)
    (call $modulo (local.get $x) (global.get $universe_length))
    (call $modulo (local.get $y) (global.get $universe_height))
    global.get $universe_length
    i32.mul
    i32.add
    i32.const 4
    i32.mul
  )

  (func $modulo (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.rem_s
    local.get $b
    i32.add
    local.get $b
    i32.rem_s
  )

  (func $get_cell (param $x i32) (param $y i32) (result i32)
    local.get $x
    local.get $y
    call $get_cell_index
    i32.load8_s
  )

  (func $set_cell (param $x i32) (param $y i32) (param $value i32)
    local.get $x
    local.get $y
    call $get_cell_index
    call $get_universe_offset
    i32.add
    local.get $value
    i32.store
  )

  (func $set_new_cell (param $x i32) (param $y i32) (param $value i32)
    local.get $x
    local.get $y
    call $get_cell_index
    call $get_new_universe_offset
    i32.add
    local.get $value
    i32.store
  )

  (func $is_cell_alive (param $x i32) (param $y i32) (result i32)
    (call $get_cell (local.get $x) (local.get $y))
  )

  (func $count_alive_neighbours (param $x i32) (param $y i32) (result i32)
    (call $get_cell (i32.sub (local.get $x) (i32.const 1))
                    (i32.sub (local.get $y) (i32.const 1)))
    (call $get_cell (local.get $x)
                    (i32.sub (local.get $y) (i32.const 1)))
    (call $get_cell (i32.add (local.get $x) (i32.const 1))
                    (i32.sub (local.get $y) (i32.const 1)))
    (call $get_cell (i32.sub (local.get $x) (i32.const 1))
                    (local.get $y))
    (call $get_cell (i32.add (local.get $x) (i32.const 1))
                    (local.get $y))
    (call $get_cell (i32.sub (local.get $x) (i32.const 1))
                    (i32.add (local.get $y) (i32.const 1)))
    (call $get_cell (local.get $x)
                    (i32.add (local.get $y) (i32.const 1)))
    (call $get_cell (i32.add (local.get $x) (i32.const 1))
                    (i32.add (local.get $y) (i32.const 1)))
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
    i32.add
  )

  (func $calculate_next_state_for_cell (param $x i32) (param $y i32) (result i32)
    (local $alive_neighbors i32)
    (call $count_alive_neighbours (local.get $x) (local.get $y))
    local.set $alive_neighbors

    (i32.or
      (i32.eq (local.get $alive_neighbors) (i32.const 3) )
      (i32.and
        (i32.eq (local.get $alive_neighbors) (i32.const 2))
        (call $is_cell_alive (local.get $x) (local.get $y))
      )
    )
  )

  (func $apply_new_universe
    call $get_universe_offset
    call $get_new_universe_offset
    call $get_universe_mem_size
    memory.copy

    call $clear_new_universe
  )

  (func $clear_universe
    call $get_universe_offset
    i32.const 0
    call $get_universe_mem_size
    memory.fill
  )

  (func $clear_new_universe
    call $get_new_universe_offset
    i32.const 0
    call $get_universe_mem_size
    memory.fill
  )

  (func $generate_random_universe (param $number_of_alive_cells i32)
    call $clear_new_universe

    (block $b
      (loop $l
        local.get $number_of_alive_cells
        i32.const 0
        i32.le_s
        br_if $b
        (local.set $number_of_alive_cells 
          (i32.sub (local.get $number_of_alive_cells) (i32.const 1)))

        call $get_random_cell
        i32.const 1
        call $set_new_cell

        br $l
      )
    )

    call $apply_new_universe
  )

  (func $evolve_universe
    (local $x i32)
    (local $y i32)
    (local.set $y (i32.const 0))
    (block $yb
      (loop $yl

        global.get $universe_height
        local.get $y
        i32.eq
        br_if $yb

        (local.set $x (i32.const 0))

        (block $xb
          (loop $xl
            global.get $universe_length
            local.get $x
            i32.eq
            br_if $xb

            local.get $x
            local.get $y
            (call $calculate_next_state_for_cell (local.get $x) (local.get $y))
            call $set_new_cell

            (local.set $x (i32.add (local.get $x) (i32.const 1)))

            br $xl
          )
        )
        (local.set $y (i32.add (local.get $y) (i32.const 1)))

        br $yl
      )
    )
    call $apply_new_universe
  )

  (export "universe_length" (global $universe_length))
  (export "universe_height" (global $universe_height))

  (export "get_cell" (func $get_cell))
  (export "set_cell" (func $set_cell))
  (export "evolve_universe" (func $evolve_universe))
  (export "generate_random_universe" (func $generate_random_universe))

)