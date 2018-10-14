--华欲专属 侍奉
local m=62200009
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c62200000")end,function() require("script/c62200000") end)
cm.named_with_AzayakaSin=true
function c62200009.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(62200009,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)
    e1:SetCondition(c62200009.spcon)
    e1:SetTarget(c62200009.sptg)
    e1:SetOperation(c62200009.spop)
    c:RegisterEffect(e1)
    --searchspta
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(62200009,1))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c62200009.con2)
    e2:SetTarget(c62200009.tg2)
    e2:SetOperation(c62200009.op2)
    c:RegisterEffect(e2)
    --MechanicalCrafter
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(62200009,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1)
    e3:SetCondition(c62200009.con3)
    e3:SetTarget(c62200009.tg3)
    e3:SetOperation(c62200009.op3)
    c:RegisterEffect(e3)
end
--
function c62200009.confilter(c)
    return c:GetControler()~=c:GetOwner()
end
function c62200009.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200009.confilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c62200009.spfilter(c,e,tp)
    return baka.check_set_AzayakaSin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c62200009.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c62200009.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c62200009.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c62200009.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c62200009.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
    Duel.Draw(1-tp,1,REASON_EFFECT)
    end
    Duel.SpecialSummonComplete()
end
--
function c62200009.con2(e,tp,eg,ep,ev,re,r,rp,c)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7f0)
        and re:GetHandler():check_set_AzayakaSin(c)
end
function c62200009.tgfilter2(c)
    return baka.check_set_AzayakaSin(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c62200009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c62200009.op2(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c62200009.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.Draw(1-tp,1,REASON_EFFECT)
    end
end
--
function c62200009.con3filter(c)
    return c:IsType(TYPE_TOKEN):IsRace(RACE_MACHINE)
end
function c62200009.con3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200009.con3filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c62200009.tg3filter(c)
    return baka.check_set_MechanicalCrafter(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c62200009.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c62200009.tg3filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c62200009.op3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c62200009.tg3filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end