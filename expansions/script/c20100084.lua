--ReLive-Fumi
local m=20100084
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c)
    --atk0
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cirn9.fumiap2)
    e1:SetTarget(cm.aztg)
    e1:SetOperation(cm.azop)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,m)
    e2:SetCondition(cm.hspcon)
    e2:SetValue(cm.hspval)
    c:RegisterEffect(e2)   
    --Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(Cirn9.clcost)
    e3:SetCondition(Cirn9.clcon)
    e3:SetTarget(cm.destg)
    e3:SetOperation(cm.desop)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
end
function cm.filter(c)
    return c:IsFaceup()
end
function cm.aztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.azop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:AddCounter(0xc99,1)
    end
    local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tg=g:GetMaxGroup(Card.GetAttack)
        if tg:GetCount()>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local sg=tg:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            local tc=sg:GetFirst()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(0)
            tc:RegisterEffect(e1)
        else 
            local tc=tg:GetFirst()
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(0)
            tc:RegisterEffect(e1)
        end
    end
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99) and (c:IsType(TYPE_LINK) or c:IsType(TYPE_SPELL+TYPE_CONTINUOUS))
end
function cm.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local zone=0
    local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
    for tc in aux.Next(lg) do
        zone=bit.bor(zone,tc:GetLinkedZone(tp))
    end
    zone=bit.band(zone,0x1f)
    return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.hspval(e,c)
    local tp=c:GetControler()
    local zone=0
    local lg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,0,nil)
    for tc in aux.Next(lg) do
        zone=bit.bor(zone,tc:GetLinkedZone(tp))
    end
    zone=bit.band(zone,0x1f)
    return 0,zone
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
    local tg=g:GetMaxGroup(Card.GetAttack)
    local dam=tg:GetFirst():GetAttack()
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,tg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tg=g:GetMaxGroup(Card.GetAttack)
        local dam=tg:GetFirst():GetAttack()
        Duel.Destroy(tg,REASON_EFFECT)
        if  dam>0 then
            Duel.Damage(1-tp,dam,REASON_EFFECT)
        end
    end
end