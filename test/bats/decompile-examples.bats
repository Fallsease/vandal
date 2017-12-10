#!/usr/bin/env bats

load test_helper

# REPOROOT

# module (use as prefix in @test messages)
M="decompile:"

# module path
MP="bin/decompile"

@test "$M check --help success" {
    run $MP --help
}

# test decompilation of each *.dasm file
@test "$M decompiles $DASM_INPUT/*.dasm successfully with -a/--disassembly flag" {
    for eg in $DASM_INPUT/*.dasm
    do
        run $MP --disassembly $eg
        assert_success
        run $MP -a $eg
        assert_success
    done
}

# test failed decompilation of each *.dasm
@test "$M fails when decompiling $DASM_INPUT/*.dasm without -a/--disassembly flag" {
    for eg in $DASM_INPUT/*.dasm
    do
        run $MP $eg
        assert_failure
    done
}

# test decompilation of each *.hex example
@test "$M decompiles $HEX_INPUT/*.hex successfully without flags" {
    for eg in $HEX_INPUT/*.hex
    do
        run $MP $eg
        assert_success
    done
}

@test "$M decompiles $HEX_INPUT/*.hex successfully with -b/--bytecode flag" {
    for eg in $HEX_INPUT/*.hex
    do
        run $MP -b $eg
        assert_success
        run $MP --bytecode $eg
        assert_success
    done
}

@test "$M produces CFG visualisation and TSV exports for $HEX_INPUT/dao_hack.hex" {
    GRAPH_OUTFILE="graph.pdf"
    TSV_OUTFILES="block.facts def.facts use.facts edge.facts entry.facts exit.facts op.facts value.facts dom.facts imdom.facts pdom.facts impdom.facts"
    TSV_OUTDIR="tsv"
    [ ! -f $GRAPH_OUTFILE ]
    [ ! -d $TSV_OUTDIR ]

    run $MP -g $GRAPH_OUTFILE -t $TSV_OUTDIR -d -b $HEX_INPUT/dao_hack.hex

    [ -s $GRAPH_OUTFILE ]
    [ -d $TSV_OUTDIR ]

    for f in $TSV_OUTFILES
    do
        [ -s $TSV_OUTDIR/$f ]
    done

    # clean up generated files
    rm $GRAPH_OUTFILE
    rm -rf $TSV_OUTDIR
}
