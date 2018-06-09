--音语—吟唱之歌女
function c22600032.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x260),1)
    c:EnableReviveLimit()
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22600032,0))
    e1:SetCategory(CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c22600032.secon)
    e1:SetTarget(c22600032.setg)
    e1:SetOperation(c22600032.seop)
    c:RegisterEffect(e1)
    --negate and atk/def down
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22600032,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1c0)
    e2:SetCountLimit(1)
    e2:SetCost(c22600032.cost)
    e2:SetTarget(c22600032.target)
    e2:SetOperation(c22600032.operation)
    c:RegisterEffect(e2)
end
function c22600032.secon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22600032.sefilter(c)
    return (c:IsCode(22600028) or c:IsCode(22600029)) and c:IsAbleToHand()
end
function c22600032.setg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600032.sefilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22600032.seop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c22600032.sefilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c22600032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    return true
end
function c22600032.filter(c)
    return c:IsFaceup()
end
function c22600032.cfilter(c)
    return c:IsFacedown() and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function c22600032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22600032.filter(chkc) end
    local c=e:GetHandler()
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        local cg=Duel.GetMatchingGroup(c22600032.cfilter,1-tp,LOCATION_REMOVED,0,nil)
        return cg:GetCount()>0 and Duel.GetMatchingGroupCount(c22600032.filter,tp,0,LOCATION_MZONE,nil)>0
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local cg=Duel.SelectMatchingCard(tp,c22600032.cfilter,tp,0,LOCATION_REMOVED,1,3,nil)
    Duel.SendtoDeck(cg,1-tp,2,REASON_COST)
    e:SetLabel(cg:GetCount())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c22600032.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c22600032.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        if not tc:IsDisabled() then
            Duel.NegateRelatedChain(tc,RESET_TURN_SET)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            e2:SetValue(RESET_TURN_SET)
            tc:RegisterEffect(e2)
        end
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetReset(RESET_EVENT+0x1fe0000)
        e3:SetValue(e:GetLabel()*-300)
        tc:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        e4:SetReset(RESET_EVENT+0x1fe0000)
        e4:SetValue(e:GetLabel()*-300)
        tc:RegisterEffect(e4)
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e5:SetCode(EVENT_PHASE+PHASE_END)
        e5:SetRange(LOCATION_MZONE)
        e5:SetCountLimit(1)
        e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e5:SetOperation(c22600032.reop)
        tc:RegisterEffect(e5)
    end
end
function c22600032.reop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
end
