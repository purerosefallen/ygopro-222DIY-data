--奇迹的轨迹
function c47580345.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCondition(c47580345.pspcon)
    e1:SetOperation(c47580345.pspop)
    c:RegisterEffect(e1)    
end
function c47580345.pspcon(e,tp,eg,ep,ev,re,r,rp)
    local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
    local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    if rpz==nil or lpz==rpz then return false end
    local lscale=lpz:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local loc=0
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
    if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    if loc==0 then return false end
    local g=nil
    if og then
        g=og:Filter(Card.IsLocation,nil,loc)
    else
        g=Duel.GetFieldGroup(tp,loc,0)
    end
    return g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
end
function c47580345.pspop(e,tp,eg,ep,ev,re,r,rp,sg,og)
    local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
    local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
    local lscale=lpz:GetLeftScale()
    local rscale=rpz:GetRightScale()
    if lscale>rscale then lscale,rscale=rscale,lscale end
    local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
    local tg=nil
    local loc=0
    local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ft2=Duel.GetLocationCountFromEx(tp)
    local ft=Duel.GetUsableMZoneCount(tp)
    local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
    if ect and ect<ft2 then ft2=ect end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then
        if ft1>0 then ft1=1 end
        if ft2>0 then ft2=1 end
            ft=1
    end
    if ft1>0 then loc=loc|LOCATION_HAND end
    if ft2>0 then loc=loc|LOCATION_EXTRA end
    if og then
        tg=og:Filter(Card.IsLocation,nil,loc):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
    else
        tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
    end
    local ce=nil
    local b1=PENDULUM_CHECKLIST&(0x1<<tp)==0
    local b2=#eset>0
    if b1 and b2 then
    local options={1163}
        for _,te in ipairs(eset) do
            table.insert(options,te:GetDescription())
        end
    local op=Duel.SelectOption(tp,table.unpack(options))
    if op>0 then
        ce=eset[op]
    end
    elseif b2 and not b1 then
    local options={}
        for _,te in ipairs(eset) do
            table.insert(options,te:GetDescription())
        end
     local op=Duel.SelectOption(tp,table.unpack(options))
            ce=eset[op+1]
     end
        if ce then
            tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
        end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=tg:SelectSubGroup(tp,aux.PendOperationCheck,true,1,#tg,ft1,ft2,ft)
    if not g then return end
    if ce then
        Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
        ce:Reset()
    end
    Duel.HintSelection(Group.FromCards(lpz))
    Duel.HintSelection(Group.FromCards(rpz))
    for tc in aux.Next(g) do
        local bool=aux.PendulumSummonableBool(tc)
        Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,bool,bool,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
    for tc in aux.Next(g) do tc:CompleteProcedure() end
end