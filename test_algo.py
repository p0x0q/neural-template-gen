def get_e2e_poswrds(tokes):
    """
    assumes a key only appears once per line...
    returns (key, num) -> word
    """
    fields = {}
    # print(tokes)
    state, num = None, 1 # 1-idx the numbering
    for toke in tokes:
        if "__start" in toke:
            assert state is None
            state = toke[7:-2]
        elif "__end" in toke:
            state, num = None, 1
        elif state is not None:
            fields[state, num] = toke
            num += 1
    return fields

print(get_e2e_poswrds(['(10)', 'Regarding', 'the', 'placement', 'of', 'the', 'movable', 'decorative', 'element,', 'one', 'embodiment', 'uses', 'a', 'pachinko', "machine's", 'playing', 'board', 'as', 'an', 'example,', 'but', 'the', 'movable', 'display', 'element', 'may,', 'for', 'example,', '__start_template__', ',', 'be', 'placed', 'inside', 'the', 'front', 'door', 'of', 'a', 'pachinko', 'machine', '(slot', 'machine).', '__end_template__.']))
