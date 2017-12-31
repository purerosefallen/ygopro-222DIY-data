--无名的存在
local m=2111002
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c2111002.matfilter,1,1)
    --Normal monster
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_SETCODE)
    e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
    e1:SetValue(0x218)
    c:RegisterEffect(e1)
    --remove
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(2111002,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,2111002)
    e1:SetCondition(c2111002.remcon)
    e1:SetTarget(c2111002.tgtg)
    e1:SetOperation(c2111002.tgop)
    c:RegisterEffect(e1)
end
function c2111002.matfilter(c)
    return c:IsSetCard(0x218) and c:GetLevel()==3
end
function c2111002.remcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c2111002.filter(c)
    return (aux.IsCodeListed(c,2111001) or c:IsCode(2111001)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c2111002.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c2111002.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c2111002.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c2111002.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end