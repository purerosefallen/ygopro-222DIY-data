--月光大剑
function c11200096.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c11200096.target)
    e1:SetOperation(c11200096.operation)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(1000)
    c:RegisterEffect(e2)
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e3)
    --equip limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EQUIP_LIMIT)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --remove
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(11200096,0))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCategory(CATEGORY_REMOVE+CATEGORY_EQUIP)
    e5:SetRange(LOCATION_SZONE)
    e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
    e5:SetCountLimit(1,112000961)
    e5:SetCondition(c11200096.con)
    e5:SetTarget(c11200096.retg)
    e5:SetOperation(c11200096.reop)
    c:RegisterEffect(e5)
    --destroy
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(11200096,1))
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_SZONE)
    e6:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
    e6:SetCountLimit(1,112000962)
    e6:SetCondition(c11200096.con)
    e6:SetTarget(c11200096.destg)
    e6:SetOperation(c11200096.desop)
    c:RegisterEffect(e6)
end
function c11200096.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c11200096.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,e:GetHandler(),tc)
    end
end
function c11200096.con(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c11200096.desfilter(c,g)
    return g:IsContains(c) 
end
function c11200096.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local cg=e:GetHandler():GetEquipTarget():GetColumnGroup()
    if chk==0 then return Duel.IsExistingMatchingCard(c11200096.desfilter,tp,0,LOCATION_ONFIELD,1,nil,cg) 
            and e:GetHandler():GetEquipTarget():GetAttackAnnouncedCount()==0 end
    local g=Duel.GetMatchingGroup(c11200096.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c11200096.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cg=c:GetEquipTarget():GetColumnGroup()
    if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetEquipTarget():IsFaceup() then
        local g=Duel.GetMatchingGroup(c11200096.desfilter,tp,0,LOCATION_ONFIELD,nil,cg)
        if g:GetCount()>0 then
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                Duel.BreakEffect()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_EQUIP)
                e1:SetCode(EFFECT_CANNOT_ATTACK)
                e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e:GetHandler():RegisterEffect(e1)
            end
        end
    end
end
function c11200096.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local cg=c:GetEquipTarget()
    if chk==0 then return cg:GetAttackAnnouncedCount()==0 and c:IsAbleToRemove() and cg:IsAbleToRemove() end
    local g=Group.FromCards(c,cg)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c11200096.reop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local cg=c:GetEquipTarget() 
    e:SetLabelObject(cg)
    local g=Group.FromCards(c,cg)
    if Duel.Remove(g,POS_FACEUP,REASON_TEMPORARY+REASON_EFFECT)~=0 then 
        if c:IsLocation(LOCATION_REMOVED) and cg:IsLocation(LOCATION_REMOVED) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
       and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            Duel.BreakEffect()
            Duel.ReturnToField(e:GetLabelObject())
            Duel.Equip(tp,c,e:GetLabelObject())
        end
    end
end


