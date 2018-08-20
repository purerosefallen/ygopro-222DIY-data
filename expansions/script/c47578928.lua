--水之天司 加百利
local m=47578928
local cm=_G["c"..m]
function c47578928.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c47578928.lcheck)
    c:EnableReviveLimit()
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47578928,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47578928.thcon)
    e3:SetTarget(c47578928.thtg)
    e3:SetOperation(c47578928.thop)
    c:RegisterEffect(e3)
    --destroy replace
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c47578928.reptg)
    e4:SetValue(c47578928.repval)
    e4:SetOperation(c47578928.repop)
    c:RegisterEffect(e4)
end
function c47578928.lcheck(g,lc)
    return g:IsExists(Card.IsSetCard,1,nil,0x5de)
end
function c47578928.thcfilter(c,ec)
    if c:IsLocation(LOCATION_MZONE) then
        return ec:GetLinkedGroup():IsContains(c)
    else
        return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
    end
end
function c47578928.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return not eg:IsContains(c) and eg:FilterCount(c22423493.thcfilter,nil,c)==3
end
function c47578928.thfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c47578928.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578928.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47578928.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47578928.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47578928.repfilter(c,tp,hc)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and hc:GetLinkedGroup():IsContains(c)
end
function c47578928.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGrave() and eg:IsExists(c47578928.repfilter,1,nil,tp,e:GetHandler()) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c47578928.repval(e,c)
    return c47578928.repfilter(c,e:GetHandlerPlayer(),e:GetHandler())
end
function c47578928.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end