--龙之骑士 兰斯洛特&维恩
function c47550010.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,3,c47550010.lcheck)
    c:EnableReviveLimit()
    --extra link
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetTarget(c47550010.mattg)
    e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e0:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e0:SetValue(c47550010.matval)
    c:RegisterEffect(e0)   
    --Twin Knight
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCode(EFFECT_ADD_ATTRIBUTE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(ATTRIBUTE_WATER)
    c:RegisterEffect(e1) 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e3)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47550010,0))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1)
    e4:SetTarget(c47550010.destg)
    e4:SetOperation(c47550010.desop)
    c:RegisterEffect(e4)
    --damage
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_BATTLE_DAMAGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetOperation(c47550010.damop)
    c:RegisterEffect(e5)
end
function c47550010.lcheck(g,lc)
    return g:IsExists(Card.IsSetCard,1,nil,0x5d0)
end
function c47550010.matval(e,c,mg)
    return c:IsCode(47550010)
end
function c47550010.mattg(e,c)
    return c:IsFaceup() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c47550010.desfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47550010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_PZONE) and c47550010.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47550010.desfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c47550010.desfilter,tp,LOCATION_MZONE+LOCATION_PZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47550010.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    local scl=tc:GetOriginalLeftScale()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(scl*200)
            c:RegisterEffect(e1)
        end 
    end
end
function c47550010.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    Duel.Damage(1-tp,atk,REASON_EFFECT)
end