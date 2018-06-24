--武装神姬 战乙女之阿尔特蕾妮
local m=14801104
local cm=_G["c"..m]
function cm.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x4811),2)
    c:EnableReviveLimit()
    --equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.eqtg)
    e1:SetOperation(cm.eqop)
    c:RegisterEffect(e1)
    --unequip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTarget(cm.sptg)
    e2:SetOperation(cm.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(cm.econ)
    e3:SetValue(cm.efilters)
    c:RegisterEffect(e3)
    --Atk up
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_EQUIP)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetValue(2100)
    c:RegisterEffect(e4)
    --special summon
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,2))
    e5:SetCode(EVENT_BATTLE_DESTROYING)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetCondition(aux.bdogcon)
    e5:SetOperation(cm.spop2)
    local e7=Effect.CreateEffect(c)  
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)  
    e7:SetRange(LOCATION_SZONE)  
    e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
    e7:SetTarget(cm.eftg1)  
    e7:SetLabelObject(e5)  
    c:RegisterEffect(e7)
    
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(cm.imtg)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e10=e6:Clone()
    e10:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e10:SetValue(aux.tgoval)
    c:RegisterEffect(e10)
    --equip
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetDescription(aux.Stringid(m,3))
    e8:SetCategory(CATEGORY_EQUIP)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1,m)
    e8:SetTarget(cm.eqtg2)
    e8:SetOperation(cm.eqop2)
    c:RegisterEffect(e8)
    --eqlimit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetCode(EFFECT_EQUIP_LIMIT)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e9:SetValue(cm.eqlimit)
    c:RegisterEffect(e9)
    --Def up
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_EQUIP)
    e11:SetCode(EFFECT_UPDATE_DEFENSE)
    e11:SetValue(2100)
    c:RegisterEffect(e11)
end

function cm.filter(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:IsSetCard(0x4811) and ct2==0
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not cm.filter(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cm.repval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
    local e5=Effect.CreateEffect(e:GetHandler())
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetTargetRange(0,1)
    e5:SetCondition(cm.sumcon)
    e5:SetTarget(cm.sumlimit)
    e5:SetLabel(Duel.GetTurnCount())
    if Duel.GetTurnPlayer()==tp then
        e5:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    else
        e5:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
    end
    Duel.RegisterEffect(e5,tp)
    local e2=e5:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,tp)
end
function cm.sumcon(e)
    return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()~=e:GetOwnerPlayer()
end
function cm.sumlimit(e,c)
    return c:IsLevelAbove(5)
end
function cm.imtg(e,c)
    return c:IsSetCard(0x4811)
end
function cm.filter2(c)
    return c:IsSetCard(0x4811) and c:IsType(TYPE_MONSTER) and not c:IsCode(14801104) and not c:IsForbidden()
end
function cm.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.eqop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        if not Duel.Equip(tp,tc,c,true) then return end
        local e8=Effect.CreateEffect(c)
        e8:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
        e8:SetType(EFFECT_TYPE_SINGLE)
        e8:SetCode(EFFECT_EQUIP_LIMIT)
        e8:SetReset(RESET_EVENT+0x1fe0000)
        e8:SetValue(cm.eqlimit1)
        tc:RegisterEffect(e8)
    end
end
function cm.eqlimit1(e,c)
    return e:GetOwner()==c
end
function cm.econ(e)
    return e:GetHandler():GetEquipTarget()
end
function cm.efilters(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.eftg1(e,c)  
    return e:GetHandler():GetEquipTarget()==c  
end
function cm.eqlimit(e,c)
    return (c:IsSetCard(0x4811) and c:IsType(TYPE_MONSTER)) or e:GetHandler():GetEquipTarget()==c
end

