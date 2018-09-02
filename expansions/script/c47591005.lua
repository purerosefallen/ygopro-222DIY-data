--五神的慈悲
local m=47591005
local cm=_G["c"..m]
function c47591005.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47591005+EFFECT_COUNT_CODE_DUEL)
    e1:SetCost(c47591005.cost)
    e1:SetCondition(c47591005.cod)
    e1:SetTarget(c47591005.tg)
    e1:SetOperation(c47591005.op)
    c:RegisterEffect(e1)
end
function c47591005.filter(c,e,tp)
    return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47591005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,5)
    if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==5
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c47591005.cfilter(c,tp)
    return c:IsCode(47591855) 
end
function c47591005.cod(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47591005.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c47591005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c47591005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47591005.op(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,47591005) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47591005.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            tc:RegisterFlagEffect(47591005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
            tc=g:GetNext()
        end
        Duel.SpecialSummonComplete()
        local tc=g:GetFirst()
        while tc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e2)
            tc:RegisterFlagEffect(47591005,RESET_EVENT+RESETS_STANDARD,0,1,fid)
            tc=g:GetNext()
        end
        g:KeepAlive()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(g)
        e1:SetCondition(c47591005.rmcon)
        e1:SetOperation(c47591005.rmop)
        Duel.RegisterEffect(e1,tp)
    end
end
function c47591005.rmfilter(c,fid)
    return c:GetFlagEffectLabel(47591005)==fid
end
function c47591005.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(c47591005.rmfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c47591005.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(c47591005.rmfilter,nil,e:GetLabel())
    Duel.SendtoGrave(tg,POS_FACEUP,REASON_EFFECT)
end