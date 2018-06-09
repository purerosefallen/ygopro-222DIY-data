--传灵 雪絮
function c22600103.initial_effect(c)
     --spirit return
    aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    
    --atk/def down
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,22600103)
    e2:SetCost(c22600103.adcost)
    e2:SetCondition(c22600103.adcon)
    e2:SetTarget(c22600103.adtg)
    e2:SetOperation(c22600103.adop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,0x1c0)
    e3:SetCondition(c22600103.con)
    c:RegisterEffect(e3)

    --search
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,22600133)
    e4:SetCondition(c22600103.secon)
    e4:SetTarget(c22600103.setg)
    e4:SetOperation(c22600103.seop)
    c:RegisterEffect(e4)
end

function c22600103.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c22600103.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
    local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
    if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,g2,1,0,0)
end

function c22600103.adop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
    if ct>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        local ct=sg:GetFirst()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(0)
        ct:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(0)
        ct:RegisterEffect(e2)
    end
end
function c22600103.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_SPIRIT)
end
function c22600103.adcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22600103.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22600103.con(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c22600103.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c22600103.secon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
    and re:GetHandler()==e:GetHandler())
end

function c22600103.filter(c)
    return c:IsSetCard(0x261) and c:IsAbleToHand()
end

function c22600103.setg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600103.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c22600103.seop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22600103.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
