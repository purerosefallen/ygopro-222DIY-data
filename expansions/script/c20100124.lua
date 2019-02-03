--Idol! ReLive!
local m=20100124
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)  
    --atk 0 cost
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(cm.atkcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.atktg)
    e2:SetOperation(cm.atkop)
    c:RegisterEffect(e2)      
end

function cm.acfilter(c)
    return c:IsFaceup() and c:IsCanAddCounter(0xc99,2)
end
function cm.filter(c,ec)
    return c:IsFaceup() and c:IsCanRemoveCounter(tp,0xc99,1,REASON_EFFECT) 
        and Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_MZONE,0,1,ec)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and cm.filter(chkc) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0xc99)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanRemoveCounter(tp,0xc99,1,REASON_EFFECT) then
        tc:RemoveCounter(tp,0xc99,1,REASON_EFFECT)
        if Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_MZONE,0,1,tc) then
            local ac=Duel.SelectMatchingCard(tp,cm.acfilter,tp,LOCATION_MZONE,0,1,1,tc)
            ac:GetFirst():AddCounter(0xc99,2)
        end
    end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,m)==0
end

function cm.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xc99)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.atkfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        tc:RegisterFlagEffect(20100070,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)   
    end
end