--觉醒十天众 卡托尔
local m=47594444
local cm=_G["c"..m]
function c47594444.initial_effect(c)
    c:SetSPSummonOnce(47594444)
    --link summon
    aux.AddLinkProcedure(c,nil,2,4,c47594444.lcheck)
    c:EnableReviveLimit()
    --serch
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)  
    e1:SetCountLimit(1,47594444)
    e1:SetCondition(c47594444.poscon)
    e1:SetTarget(c47594444.thtg)
    e1:SetOperation(c47594444.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --check
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47594444,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47594445)
    e3:SetOperation(c47594444.op)
    c:RegisterEffect(e3)  
    --mudeki
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47594444.atktg)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(c47594444.atktg)
    e6:SetValue(aux.tgoval)
    c:RegisterEffect(e6)
end
function c47594444.lcheck(g,lc)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
end
function c47594444.poscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47594444.atktg(e,c)
    return c:IsAttribute(ATTRIBUTE_WATER) or c:IsSetCard(0x5d1)
end
function c47594444.filter(c)
    return c:IsCode(47591004) and c:IsAbleToHand()
end
function c47594444.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47594444.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c47594444.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47594444.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47594444.op(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    Duel.ConfirmDecktop(tp,4)
    local g=Duel.GetDecktopGroup(tp,4)
    if g:GetCount()>0 then
        if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then
            if Duel.SelectYesNo(tp,aux.Stringid(47594444,2)) then
                Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
                local sg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
                if sg:GetFirst():IsAbleToHand() then
                    Duel.SendtoHand(sg,nil,REASON_EFFECT)
                    Duel.ConfirmCards(1-tp,sg)
                    Duel.ShuffleHand(tp)
                end
            end
        end
        Duel.ShuffleDeck(tp)
    end
end