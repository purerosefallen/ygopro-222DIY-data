--ReLive-Choros
local m=20100128
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    c:EnableCounterPermit(0xc99)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
    c:EnableReviveLimit()
    --+1
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetOperation(cm.op1)
    c:RegisterEffect(e2)
    --+2
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,1))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(Cirn9.clcost)
    e3:SetOperation(cm.op2)
    c:RegisterEffect(e3)
    cm.ClimaxAct=e3
    
end
function cm.lcheck(g,lc)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0xc99)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,20100051,RESET_PHASE+PHASE_END,0,1)    
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")                        
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.RegisterFlagEffect(tp,20100051,0,0,0) 
    Duel.RegisterFlagEffect(tp,20100051,0,0,0) 
    local ea=Duel.GetFlagEffect(tp,20100050)
    local eb=Duel.GetFlagEffect(tp,20100051)
    local ec=6-ea+eb
    Debug.Message("ReLive卡行动次数剩余"..ec.."次  DA☆ZE")                        
end