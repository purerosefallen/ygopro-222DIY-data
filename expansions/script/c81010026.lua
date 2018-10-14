--姬川友纪
function c81010026.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --level
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1)
    e2:SetTarget(c81010026.lvtg)
    e2:SetOperation(c81010026.lvop)
    c:RegisterEffect(e2)
end
function c81010026.filter(c)
    return c:IsFaceup()
end
function c81010026.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c81010026.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c81010026.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c81010026.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c81010026.lvop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(100)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end

end
