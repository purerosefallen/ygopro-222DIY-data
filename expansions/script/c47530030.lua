--沙扎比
function c47530030.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4)
    c:EnableReviveLimit()    
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c47530030.val)
    c:RegisterEffect(e1)
    --soul of zeon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47530030.incon1)
    e2:SetValue(c47530030.efilter)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47530030.incon2)
    e3:SetOperation(c47530030.atkop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
    e4:SetCode(EVENT_CHAINING)
    e4:SetCondition(c47530030.incon3)
    e4:SetCost(c47530030.negcost)
    e4:SetTarget(c47530030.negtg)
    e4:SetOperation(c47530030.negop)
    c:RegisterEffect(e4) 
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e5:SetCondition(c47530030.incon4)
    e5:SetTarget(c47530030.aitg)
    e5:SetOperation(c47530030.aiop)
    c:RegisterEffect(e5)
end
function c47530030.val(e,c)
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)*300
end
function c47530030.incon1(e,c)
    local c=e:GetHandler()
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=2
end
function c47530030.incon2(e,c)
    local c=e:GetHandler()
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=3
end
function c47530030.incon4(e,c)
    local c=e:GetHandler()
    return Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>8
end
function c47530030.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47530030.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetTargetRange(0,LOCATION_ONFIELD)
    e1:SetTarget(c47530030.distg)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAIN_SOLVING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetOperation(c47530030.disop)
    e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e3,tp)
    local tc=Duel.GetAttackTarget()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(0)
        e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e2,true)
end
function c47530030.distg(e,c)
    return c~=e:GetHandler()
end
function c47530030.disop(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if bit.band(loc,LOCATION_ONFIELD)~=0 then
        Duel.NegateEffect(ev)
    end
end
function c47530030.incon3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_MZONE,LOCATION_MZONE,nil,RACE_MACHINE)>=4 and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp==1-tp
end
function c47530030.cfilter(c,g)
    return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c47530030.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47530030.cfilter,1,nil,lg) end
    local g=Duel.SelectReleaseGroup(tp,c47530030.cfilter,1,1,nil,lg)
    Duel.Release(g,REASON_COST)
end
function c47530030.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local ng=Group.CreateGroup()
    local dg=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and Duel.IsChainNegatable(i) then
            local tc=te:GetHandler()
            ng:AddCard(tc)
            if tc:IsOnField() and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
                dg:AddCard(tc)
            end
        end
    end
    Duel.SetTargetCard(dg)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function c47530030.negop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Group.CreateGroup()
    for i=1,ev do
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp and Duel.NegateActivation(i) then
            local tc=te:GetHandler()
            if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
                tc:CancelToGrave()
                dg:AddCard(tc)
            end
        end
    end
    Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function c47530030.hspfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c47530030.aitg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47530030.hspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c47530030.hspfilter,1-tp,LOCATION_EXTRA,0,1,nil,e,1-tp) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function c47530030.aiop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x1e,0x1e,nil)
    if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
        local g=Duel.GetMatchingGroup(c47530030.hspfilter,1-tp,LOCATION_EXTRA,0,nil,e,1-tp)
        if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.SpecialSummon(sg,0,1-tp,1-tp,true,false,POS_FACEUP)
        end   
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
        local g1=Duel.GetMatchingGroup(c47530030.hspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
        if g1:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:Select(tp,1,1,nil)
            Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
        end
    end
end