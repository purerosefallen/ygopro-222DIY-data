--雷鸣的星晶兽 巴尔
local m=47510019
local cm=_G["c"..m]
function c47510019.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510019)
    e2:SetTarget(c47510019.thtg)
    e2:SetOperation(c47510019.thop)
    c:RegisterEffect(e2) 
    --synchro limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetValue(c47510019.synlimit)
    c:RegisterEffect(e3)
    --serch
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,47510020)
    e4:SetTarget(c47510019.tetg)
    e4:SetOperation(c47510019.teop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --summoneffect
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_EXTRA)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCountLimit(1,47510000)
    e6:SetCost(c47510019.cost)
    e6:SetOperation(c47510019.op)
    c:RegisterEffect(e6)
    --synchro effect
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47510019.sccon)
    e7:SetTarget(c47510019.sctarg)
    e7:SetOperation(c47510019.scop)
    c:RegisterEffect(e7)
end
function c47510019.pefilter(c)
    return c:IsRace(RACE_ROCK) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510019.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510019.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510019.filter(c)
    return c:IsAbleToGrave() and c:IsSetCard(0x5da)
end
function c47510019.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c47510019.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510019.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c47510019.filter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c47510019.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,nil,REASON_EFFECT)
    end
end
function c47510019.synlimit(e,c)
    if not c then return false end
    return not c:IsAttribute(ATTRIBUTE_EARTH) or c:IsSetCard(0x5da)
end
function c47510019.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x5da) and not c:IsForbidden()
end
function c47510019.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510019.tefilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,2,tp,LOCATION_GRAVE)
end
function c47510019.teop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47510019,3))
    local g=Duel.SelectMatchingCard(tp,c47510019.tefilter,tp,LOCATION_GRAVE,0,1,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end
function c47510019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510019.filter1(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) or c:IsSetCard(0x5da)
end
function c47510019.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_DISABLE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5da))
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_DISEFFECT)
    Duel.RegisterEffect(e2,tp)
end
function c47510019.sccon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
        and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c47510019.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(47510019)==0
        and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) end
    c:RegisterFlagEffect(47510019,RESET_CHAIN,0,1)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47510019.scop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:Select(tp,1,1,nil)
        Duel.SynchroSummon(tp,sg:GetFirst(),c)
    end
end
