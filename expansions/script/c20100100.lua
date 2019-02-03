--ReLive-Michiru
local m=20100100
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    Cirn9.ReLink(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()   
    --extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetCountLimit(1)
    e1:SetCondition(cm.sumcon)
    e1:SetCost(Cirn9.sap2)
    e1:SetTarget(cm.sumtg)
    e1:SetOperation(cm.sumop)
    c:RegisterEffect(e1) 
    --halve damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CHANGE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.hdcon)
    e2:SetTargetRange(1,0)
    e2:SetValue(cm.val)
    c:RegisterEffect(e2)
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetOperation(cm.clop)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.matfilter(c)
    return c:IsLinkSetCard(0xc99) and not c:IsLinkCode(m)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)==0
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSummon(tp) end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xc99)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetDescription(aux.Stringid(m,2))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc99))
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0xc99,2)
    end
end
function cm.val(e,re,dam,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return dam/2 
    else return dam
    end
end
function cm.hdcon(e,tp)
    return Cirn9.IsReLinkState(e:GetHandler())
end
function cm.clop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetValue(cm.damval)
    e1:SetReset(RESET_PHASE+PHASE_END,3)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    e2:SetReset(RESET_PHASE+PHASE_END,3)
    Duel.RegisterEffect(e2,tp)
end
function cm.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0
    else return val end
end
