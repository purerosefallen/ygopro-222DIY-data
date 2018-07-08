--茧墨今天也在吃巧克力
function c22261211.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --SpecialSummonToken
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22261211,0))
    e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c22261211.condition)
    e1:SetTarget(c22261211.target)
    e1:SetOperation(c22261211.operation)
    c:RegisterEffect(e1)
    --SearchCard
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22261211,1))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1)
    e3:SetTarget(c22261211.thtg)
    e3:SetOperation(c22261211.thop)
    c:RegisterEffect(e3)  
end
function c22261211.IsMayuAzaka(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_MayuAzaka
end
function c22261211.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c22261211.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) and Duel.GetMZoneCount(tp)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22261211.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<1 or not Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) then return end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local token=Duel.CreateToken(tp,22269998)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22261211.thfilter(c)
    return c22261211.IsMayuAzaka(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c22261211.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,22269998) then
        e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    end
    if chk==0 then return Duel.IsExistingMatchingCard(c22261211.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22261211.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22261211.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end