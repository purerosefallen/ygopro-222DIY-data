--真龙 斯卡哈
local m=47512001
local cm=_G["c"..m]
function c47512001.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,3,c47512001.lcheck)
    c:EnableReviveLimit()  
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47512001,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47512001)
    e2:SetTarget(c47512001.sptg)
    e2:SetOperation(c47512001.spop)
    c:RegisterEffect(e2)    
end
function c47512001.lcheck(g)
    return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c47512001.tfilter(c,att,e,tp)
    return c:IsType(TYPE_PENDULUM) and c:IsAttribute(att) and c:IsAbleToExtra() and (c:IsSetCard(0x5da) or c:IsSetCard(0x5de) or c:IsSetCard(0x5d5))
end
function c47512001.filter(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c47512001.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp)
end
function c47512001.chkfilter(c,att)
    return c:IsFaceup() and c:IsAttribute(att)
end
function c47512001.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47512001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE+LOCATION_EXTRA) and c47512001.chkfilter(chkc,e:GetLabel()) end
    if chk==0 then return Duel.IsExistingTarget(c47512001.filter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil,e,tp) end
    local g=Duel.SelectTarget(tp,c47512001.filter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    e:SetLabel(g:GetFirst():GetAttribute())
end
function c47512001.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local att=tc:GetAttribute()
    local sg=Duel.SelectMatchingCard(tp,c47512001.tfilter,tp,LOCATION_DECK,0,1,1,nil,att,e,tp)
    if sg:GetCount()>0 and Duel.SendtoExtraP(sg,nil,REASON_EFFECT) and Duel.GetLocationCountFromEx(tp)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47512001.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47512001.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47512001.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not c:IsType(TYPE_PENDULUM)
end