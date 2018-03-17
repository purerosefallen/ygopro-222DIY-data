--影灵刻使 秘法师
local m=10904028
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(30312361,0))
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,m)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(cm.tgtg)
    e1:SetOperation(cm.tgop)
    c:RegisterEffect(e1)    
end
function cm.filter(c)
    return c:IsSetCard(0x237) and c:IsType(TYPE_EFFECT) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
            Duel.BreakEffect()
            local tc=g:GetFirst()
            local code=tc:GetOriginalCode()
            if c:IsRelateToEffect(e) and c:IsFaceup() then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
                e1:SetReset(RESET_EVENT+0x1ff0000)
                e1:SetCode(EFFECT_CHANGE_CODE)
                e1:SetValue(code)
                c:RegisterEffect(e1)
                c:CopyEffect(code,RESET_EVENT+0x1fe0000)
            end
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
    return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK 
end