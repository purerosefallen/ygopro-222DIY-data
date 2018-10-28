--炼金术师 姬塔
local m=47500001
local cm=_G["c"..m]
function c47500001.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500001,0))
    e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c47500001.thtg)
    e1:SetOperation(c47500001.thop)
    c:RegisterEffect(e1)    
    --destroy and spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500001,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47500001)
    e2:SetTarget(c47500001.sptg)
    e2:SetOperation(c47500001.spop)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47500001,2))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47501001)
    e3:SetCost(c47500001.thcost)
    e3:SetTarget(c47500001.thtg2)
    e3:SetOperation(c47500001.thop2)
    c:RegisterEffect(e3)
    --code
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_CHANGE_CODE)
    e4:SetRange(LOCATION_MZONE+LOCATION_PZONE+LOCATION_GRAVE+LOCATION_EXTRA)
    e4:SetValue(47500000)
    c:RegisterEffect(e4)
end
c47500001.card_code_list={47500000}
function c47500001.thfilter(c)
    return c:IsAbleToHand()
end
function c47500001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500001.thfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c47500001.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47500001.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
        Duel.Recover(tp,1000,REASON_EFFECT)    
    end
end
function c47500001.spfilter(c,e,tp)
    return (aux.IsCodeListed(c,47500000) or c:IsCode(47500000)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47500001.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and chkc:IsFaceup() end
    if chk==0 then
        local ft=Duel.GetMZoneCount(tp)
        if ft<-1 then return false end
        local loc=LOCATION_ONFIELD
        if ft==0 then loc=LOCATION_MZONE end
        e:SetLabel(loc)
        return Duel.IsExistingTarget(Card.IsFaceup,tp,loc,0,1,e:GetHandler())
            and Duel.IsExistingMatchingCard(c47500001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,e:GetLabel(),0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47500001.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if Duel.GetMZoneCount(tp)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c47500001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c47500001.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c47500001.thfilter1(c)
    return (aux.IsCodeListed(c,47500000) or c:IsCode(47500000))
end
function c47500001.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500001.thfilter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47500001.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47500001.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end