--加速装置
local m=80000053
local cm=_G["c"..m]
cm.is_named_with_yvwan=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --instant
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
    e2:SetCondition(cm.condition)  
    e2:SetTarget(cm.target1)
    e2:SetOperation(cm.activate1)
    c:RegisterEffect(e2)
    --instant
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
    e3:SetCondition(cm.condition)
    e3:SetTarget(cm.target2)
    e3:SetOperation(cm.activate2)
    c:RegisterEffect(e3)
    --extra summon
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e4:SetTarget(aux.TargetBoolFunction(Sym.isyvwan))
    c:RegisterEffect(e4)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local tn=Duel.GetTurnPlayer()
    local ph=Duel.GetCurrentPhase()
    return tn==tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function cm.filter1(c,tp)
    return Sym.canexchange(c) and Duel.GetMZoneCount(tp)>0 and Sym.canspsumaf(c,tp)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_HAND,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_HAND,0,1,1,nil)
    local c=g:GetFirst()
    if Duel.GetMZoneCount(tp)>0 and Sym.canspsumaf(c,tp) then
        local tcode=c.dfc_back_side
        c:SetEntityCode(tcode,true)
        c:ReplaceEffect(tcode,0,0)
        Duel.BreakEffect()
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.filter2(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and Sym.isyvwan(c)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)
    end
end