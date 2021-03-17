# ============================================================================
# Name        : mult8x8_tb.do
# Author      : Letícia de Oliveira Nunes
# Version     : 0.1
# Copyright   : Renan, Departamento de Eletrônica, Florianópolis, IFSC
# Description : Mult 8x8 FSM
# ============================================================================

#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom componentes/addernbits.vhd 
vcom componentes/mult.vhd
vcom componentes/mux_when.vhd 
vcom componentes/shifter.vhd 
vcom componentes/seven_segment_cntrl.vhd 
vcom componentes/reg.vhd 
vcom componentes/counter.vhd 
vcom componentes/mult_control.vhd 
vcom mult_x8x.vhd 
vcom testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -t ns work.testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
add wave -divider " ENTRADAS "
add wave -radix binary  -label clk      /clk
add wave -radix hex     -label a        /dataa
add wave -radix hex     -label b        /datab
add wave -radix binary  -label start    /start
add wave -radix binary  -label reset_a  /reset_a

add wave -divider " PROCESSOS "
add wave -radix dec     -label sum          /dut/adder/sum
add wave -radix dec     -label product_mult /dut/mult/prod
add wave -radix dec     -label mux_outa     /dut/mux_when_a/mux_out
add wave -radix dec     -label mux_outb     /dut/mux_when_b/mux_out
add wave -radix dec     -label shift_out    /dut/shifter/shift_out
add wave -radix dec     -label product8x8   /dut/registrador/prod_reg_out
add wave -radix binary  -label count        /dut/fsm/count

add wave -divider " FSM "
add wave -radix dec     -label fsmclock     /dut/fsm/clk
add wave -radix dec     -label fsmreset     /dut/fsm/reset_a
add wave -radix dec     -label fsmstart     /dut/fsm/start
add wave -radix binary  -label fsminput     /dut/fsm/input_sel
add wave -radix binary  -label fsmshift     /dut/fsm/shift_sel
add wave -radix dec     -label fsmstateout  /dut/fsm/state_out
add wave -radix dec     -label fsmdone      /dut/fsm/done
add wave -radix dec     -label fsmclk_ena   /dut/fsm/clk_ena
add wave -radix dec     -label fsmsclr_n    /dut/fsm/sclr_n
add wave -radix dec     -label fsmstate     /dut/fsm/state

add wave -divider " REGISTRADOR "
add wave -radix dec     -label regclk_ena   /dut/registrador/clk_ena
add wave -radix dec     -label regsclr_n    /dut/registrador/sclr_n

#Como mostrar sinais internos do processo 

#Simula até um 100ns
run 100ns

wave zoomfull
#write wave wave.ps