def take_magic_damage(health, resist, amp, spell_power):
    total_max_damn = spell_power * amp
    actual_dam_dealt = total_max_damn - resist
    new_health = health - actual_dam_dealt
    return new_health