--ReLive-Yachiyo
local m=20100106
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    Cirn9.ReLink(c)
    --link summon
    aux.AddLinkProcedure(c,cm.matfilter,1,1)
    c:EnableReviveLimit()    
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1)
    e1:SetCost(Cirn9.sap2)
    e1:SetCondition(cm.atkcon)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1) 
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(cm.atkval)
    c:RegisterEffect(e2)
    --Get Effect 
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.getg)
    e3:SetOperation(cm.geop)
    c:RegisterEffect(e3)  
    cm.ClimaxAct=e3
end
function cm.matfilter(c)
    return c:IsLinkSetCard(0xc99) and not c:IsLinkCode(m)
end
function cm.atkcon(e)
    local c=e:GetHandler()
    local tp=c:GetControler()
    return c:GetLinkedGroup():FilterCount(Card.IsControler,nil,1-tp)==0
end
function cm.filter(c)
    return c:IsFaceup() and c:GetBaseAttack()>0 and c:IsPosition(POS_ATTACK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
        c:AddCounter(0xc99,2)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tc:GetBaseAttack())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function cm.atkval(e,c)
    local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
    return g:GetSum(Card.GetBaseAttack)
end
function cm.getg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end

function cm.geop(e,tp,eg,ep,ev,re,r,rp)
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        while sc do
            if (sc:GetFlagEffect(m)==0) then
                local e1=Effect.CreateEffect(sc)
                e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
                e1:SetCode(EVENT_PHASE+PHASE_END)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetRange(LOCATION_MZONE)
                e1:SetCountLimit(1)
                e1:SetOperation(cm.damop)
                sc:RegisterEffect(e1)
                sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
            end
            sc=g:GetNext()
        end
    end
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    local p=e:GetHandler():GetControler()
    Duel.Hint(HINT_CARD,0,m)
    Duel.Damage(p,500,REASON_EFFECT)
end