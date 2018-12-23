--魔龙统 法尔提
function c47551109.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,c47551109.mfilter,8,2) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47551109.psplimit)
    c:RegisterEffect(e1)  
    --pendulum set
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47551109)
    e2:SetCondition(c47551109.tpencon)
    e2:SetTarget(c47551109.tpentg)
    e2:SetOperation(c47551109.tpenop)
    c:RegisterEffect(e2)
    --battle
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --pendulum
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetCondition(c47551109.pencon)
    e5:SetTarget(c47551109.pentg)
    e5:SetOperation(c47551109.penop)
    c:RegisterEffect(e5)
    --sunmoneffect
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCountLimit(1)
    e6:SetCost(c47551109.cost)
    e6:SetTarget(c47551109.distg)
    e6:SetOperation(c47551109.disop)
    c:RegisterEffect(e6)
end
c47551109.pendulum_level=8
function c47551109.IsGran(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_Ma_Elf 
end
function c47551109.mfilter(c,xyzc)
    return c:IsType(TYPE_PENDULUM)
end
function c47551109.pefilter(c)
    return c:IsRace(RACE_DRAGON) or c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_WYRM)
end
function c47551109.psplimit(e,c,tp,sumtp,sumpos)
    return not c47551109.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47551109.tcfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47551109.tpencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47551109.tcfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47551109.tpenfilter(c)
    return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x5d0) or c:IsSetCard(0x5da) or c:IsSetCard(0x5de) or c:IsSetCard(0x5d3) or aux.IsCodeListed(c,47500000) or c:IsSetCard(0x813) or c47551109.IsGran(c))
end
function c47551109.tpentg(e,tp,eg,ep,ev,re,r,rp,chk)
    local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47551109.tpenfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetTargetCard(sc)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
end
function c47551109.tpenop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c47551109.tpenfilter,tp,LOCATION_DECK,0,1,1,nil)
        local tc=g:GetFirst()
        if tc then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        end
    end
end
function c47551109.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47551109.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0 end
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47551109.penop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47551109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47551109.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47551109.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    local atk=tc:GetBaseAttack()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(atk-500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
       tc=g:GetNext()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
    if rg:GetCount()>0 then
       Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
    end
end