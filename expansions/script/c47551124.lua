--蝴蝶幻刃
function c47551124.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE+CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,47551124)
    e1:SetTarget(c47551124.target)
    e1:SetOperation(c47551124.activate)
    c:RegisterEffect(e1)    
    --Damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,47551125)
    e2:SetTarget(c47551124.damtg)
    e2:SetOperation(c47551124.damop)
    c:RegisterEffect(e2)
    --act in hand
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e3:SetCondition(c47551124.handcon)
    c:RegisterEffect(e3)
end
c47551124.card_code_list={47500000}
function c47551124.filter(c)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0x5d0)
end
function c47551124.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return true end
    for i=1,ev do
        local ng=Group.CreateGroup()
        local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp then
            local tc=te:GetHandler()
            ng:AddCard(tc)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47551124.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,ng,ng:GetCount(),0,0)
end
function c47551124.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetLabelObject(tc)
        e1:SetCountLimit(1)
        e1:SetOperation(c47551124.retop)
        Duel.RegisterEffect(e1,tp)
        for i=1,ev do
            local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
            if tgp~=tp then 
                if Duel.NegateEffect(i)~=0 then
                    Duel.Damage(1-tp,500,REASON_EFFECT)
                end
            end
        end
    end
end
function c47551124.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
end
function c47551124.damfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0x5d0) or c:IsCode(47500000)) and c:IsType(TYPE_MONSTER)
end
function c47551124.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47551124.damfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47551124.damfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47551124.damfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47551124.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()   
    local tc=Duel.GetFirstTarget() 
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EVENT_BATTLE_DAMAGE)
        e2:SetOperation(c47551124.regop)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+EVENT_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(47551124,2))
    end
end
function c47551124.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetBaseAttack()/2
    Duel.Damage(1-tp,atk,REASON_EFFECT)
end
function c47551124.hafilter(c)
    return c:IsFaceup() and (c:IsCode(47510227) or c:IsCode(47510225))
end
function c47551124.handcon(e)
    return Duel.IsExistingMatchingCard(c47551124.hafilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end