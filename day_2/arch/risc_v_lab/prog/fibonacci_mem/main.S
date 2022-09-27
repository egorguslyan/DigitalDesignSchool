            .text

start:      li    t4, 0x10010000
            j fibonacci_2bytes

fibonacci:
            li    t2, 10
            li    t0, 1
            li    t1, 1
            sw	  t0, (t4)
            addi  t4, t4, 0x4
            sw	  t1, (t4)
fibonacci_loop:
            mv    a0, t1
            add   t1, t0, t1
            mv    t0, a0
            addi  t2, t2, -1
            addi  t4, t4, 0x4
            sw	  t1, (t4)
            bnez  t2,  fibonacci_loop
            j end

fibonacci_hop:
            li    t2, 10
            li    t0, 1
            li    t1, 1
            sw	  t0, (t4)
            addi  t4, t4, 0x4
            sw	  t1, (t4)
fibonacci_hop_loop:
            mv    a0, t1
            add   t1, t0, t1
            mv    t0, a0
            addi  t2, t2, -1
            addi  t4, t4, 0x8
            sw	  t1, (t4)
            bnez  t2,  fibonacci_hop_loop
            j end

fibonacci_2bytes:
            li    t2, 10
            li    t0, 1
            li    t1, 1
            sw	  t0, (t4)
            addi  t4, t4, 0x4
            sw	  t1, (t4)
fibonacci_2bytes_loop:
            mv    a0, t1
            add   t1, t0, t1
            mv    t0, a0
            addi  t2, t2, -1
            addi  t4, t4, 0x2
            sh	  t1, (t4)
            bnez  t2,  fibonacci_2bytes_loop
            j end

a:          li t2, 20
a_loop:     mv    a0, t1
            addi  t1, 0x2
            mv    t0, a0
            addi  t4, t4, 0x4
            sw	  t1, (t4)
            addi  t2, t2, -1
            bnez  t2,  a_loop
            j end

end: