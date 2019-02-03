--ReLive-Lalafin
local m=20100092
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2,cm.ovfilter,aux.Stringid(m,2),2,cm.xyzop)
    c:EnableReviveLimit() 
    --atk down
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetCost(Cirn9.fap1)
    e1:SetTarget(cm.atktg)
    e1:SetOperation(cm.atkop)
    c:RegisterEffect(e1)   
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(Cirn9.clcon)
    e2:SetCost(Cirn9.clcost)
    e2:SetTarget(cm.destg)
    e2:SetOperation(cm.desop)
    c:RegisterEffect(e2)
    cm.ClimaxAct=e2
end
function cm.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99) and not c:IsCode(m)
end
function cm.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.nzatk,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        while sc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
            e1:SetValue(-300)
            sc:RegisterEffect(e1)
            sc=g:GetNext()
        end
    end
    e:GetHandler():AddCounter(0xc99,1)
end

function cm.desfilter(c)
    local ba=c:GetBaseAttack()
    local ca=c:GetAttack()
    return (ca>ba) and c:IsFaceup()
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(g,REASON_EFFECT)
end