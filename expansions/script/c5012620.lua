--木原唯一
function c5012620.initial_effect(c)
     --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x250),1)
    c:EnableReviveLimit()
    --
    aux.EnablePendulumAttribute(c,false)
    --copy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(5012620,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c5012620.cost)
    e1:SetCondition(c5012620.thcon)
    e1:SetOperation(c5012620.operation)
    c:RegisterEffect(e1)
    
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c5012620.destg)
    e2:SetOperation(c5012620.desop)
    c:RegisterEffect(e2)
--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_ADD_SETCODE)
    e3:SetValue(0x250)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetTarget(c5012620.desreptg)
    c:RegisterEffect(e4)
end
function c5012620.filter(c)
    return c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function c5012620.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c5012620.filter,tp,0,LOCATION_GRAVE,LOCATION_GRAVE,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c5012620.filter,tp,0,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c5012620.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c5012620.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local code=e:GetLabel()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetCode(EFFECT_CHANGE_CODE)
        e1:SetValue(code)
        c:RegisterEffect(e1)
        c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
    end
end
function c5012620.rstop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cid=e:GetLabel()
    c:ResetEffect(cid,RESET_COPY)
    local e1=e:GetLabelObject()
    e1:Reset()
    Duel.HintSelection(Group.FromCards(c))
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c5012620.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c5012620.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
        Duel.Destroy(g,REASON_EFFECT)
end
function c5012620.repfilter(c)
    return  c:IsAbleToRemoveAsCost()
end
function c5012620.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE) 
        and Duel.IsExistingMatchingCard(c5012620.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(5012620,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c5012620.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_COST)
        return true
    else return false end
end