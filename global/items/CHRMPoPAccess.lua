-- Pop Progression Charms

local flag_count = 0;

function event_scale_calc(e)
    flag_count = 0; -- reset on each scan
    lookup(e);
    e.self:SetScale(flag_count / 10);

end


function lookup(e)
    local qglobals = eq.get_qglobals(e.owner);
    local flags = {
        'pop_poi_behometh_flag',
        'pop_pod_elder_fuirstel',
        'pop_poj_valor_storms',
        'pop_pov_aerin_dar',
        'pop_pos_askr_the_lost_final',
        'pop_cod_final',
        'pop_hohb_marr',
        'pop_sol_ro_solusk',
        'pop_elemental_grand_librarian',
        'pop_time_maelin'
    }

    for n = 1, 10 do
        local flag_check = flags[n];
        if qglobals[flag_check] ~= nil then
            flag_count = flag_count +1;
        end
    end
end
