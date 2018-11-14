--地心用大型钻头机 加拉尔霍恩
function c47511919.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47511919.psplimit)
    c:RegisterEffect(e1)   
    --return
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47511919,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47511919)
    e2:SetTarget(c47511919.thtg)
    e2:SetOperation(c47511919.thop)
    c:RegisterEffect(e2)  
    --special summon
    local e3=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47511919,1))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47510810)
    e3:SetCondition(c47511919.spscon)
    e3:SetOperation(c47511919.spsop)
    c:RegisterEffect(e3) 
    --reborn
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47511919,2))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1,47510893)
    e4:SetCondition(c47511919.con)
    e4:SetTarget(c47511919.tg)
    e4:SetOperation(c47511919.op)
    c:RegisterEffect(e4)
    --spsummon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47511919,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetRange(LOCATION_HAND)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,47510893)
    e5:SetCondition(c47511919.spcon1)
    e5:SetTarget(c47511919.sptg1)
    e5:SetOperation(c47511919.spop1)
    c:RegisterEffect(e5)
end
function c47511919.cfilter1(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_MACHINE) and (c:GetPreviousLocation()==LOCATION_GRAVE or c:GetPreviousLocation()==LOCATION_HAND)
end
function c47511919.spcon1(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47511919.cfilter1,1,nil)
end
function c47511919.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c47511919.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47511919.ttfilter,tp,LOCATION_GRAVE,0,1,1,c)
    if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)    
    end
end
function c47511919.con(e,tp,eg,ep,ev,re,r,rp)
    local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    return bit.band(loc,LOCATION_HAND)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetOriginalRace()==RACE_MACHINE and re:GetHandler():GetOriginalAttribute()==ATTRIBUTE_EARTH
end
function c47511919.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c47511919.ttfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAbleToGrave()
end
function c47511919.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoHand(c,tp,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,c47511919.ttfilter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end
function c47511919.spcfilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function c47511919.spscon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47511919.spcfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c47511919.spsop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c47511919.spcfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function c47511919.pefilter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47511919.psplimit(e,c,tp,sumtp,sumpos)
    return not c47511919.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47511919.filter(c)
    return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsAbleToHand()
end
function c47511919.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingTarget(c47511919.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c47511919.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c47511919.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47511919.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
        local g=Duel.SelectMatchingCard(tp,c47511919.filter,tp,LOCATION_GRAVE,0,1,1,nil) 
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
        end
    end
end