--ReLive-Aruru
local m=20100094
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    --xyz summon
    aux.AddXyzProcedure(c,nil,4,2,cm.ovfilter,aux.Stringid(m,2),2,cm.xyzop)
    c:EnableReviveLimit()  
    --add counter
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(Cirn9.arrap1)
    e1:SetTarget(cm.actg)
    e1:SetOperation(cm.acop)
    c:RegisterEffect(e1)   
    --add counter all
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(Cirn9.clcon)
    e2:SetCost(Cirn9.clcost)
    e2:SetTarget(cm.cltg)
    e2:SetOperation(cm.clop)
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

function cm.acfilter(c)
    return c:IsCanAddCounter(0xc99,1) and c:GetFlagEffect(m)<1 and c:IsFaceup() and c:IsSetCard(0xc99)
end

function cm.clfilter(c)
    return c:IsCanAddCounter(0xc99,1) and c:IsFaceup() and c:IsSetCard(0xc99)
end

function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsCanAddCounter(0x1,1) end
    if chk==0 then return Duel.IsExistingTarget(cm.acfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
    local g=Duel.SelectTarget(tp,cm.acfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0xc99,1) then
        tc:AddCounter(0xc99,1)
        tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
        if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
        c:AddCounter(0xc99,1)
    end
end
function cm.cltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.clfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function cm.clop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local g=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do 
        tc:AddCounter(0xc99,1)
        tc=g:GetNext()
    end
end