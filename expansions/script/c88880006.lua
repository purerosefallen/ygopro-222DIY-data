--Earth Core of the Mecha Blades
function c88880006.initial_effect(c)
--xyz summon
    aux.AddXyzProcedure(c,c88880006.mfilter,4,2,c88880006.ovfilter,aux.Stringid(88880006,0),2,c88880006.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88880006,2))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCountLimit(1,88880006)
    e1:SetCondition(c88880006.tgcon)
    e1:SetTarget(c88880006.target)
    e1:SetOperation(c88880006.activate)
    c:RegisterEffect(e1)
end

function c88880006.mfilter(c)
    return c:IsSetCard(0xffd) and not c:IsCode(88880006)
end
function c88880006.cfilter(c)
    return c:IsSetCard(0xffd)
end
function c88880006.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xffd) and not c:IsCode(88880006)
end
function c88880006.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c88880006.cfilter,tp,LOCATION_HAND,0,1,nil)
    and Duel.GetFlagEffect(tp,88880006)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,c88880006.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
    end
end
function c88880006.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c88880006.filter(c)
    return c:IsSetCard(0xffd) and c:IsAbleToHand()
end
function c88880006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c88880006.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c88880006.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c88880006.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end