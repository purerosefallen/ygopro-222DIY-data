--ReLive-Akira
local m=20100098
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c20100002") end,function() require("script/c20100002") end)
function cm.initial_effect(c)
    Cirn9.ReLiveMonster(c) 
    --hand link 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(cm.hltg)
    e1:SetCost(Cirn9.ap1)
    e1:SetOperation(cm.hlop)
    c:RegisterEffect(e1)    
    --move
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCategory(CATEGORY_DRAW+CATEGORY_COUNTER)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(Cirn9.ap2)
    e2:SetTarget(cm.mvtg)
    e2:SetOperation(cm.mvop)
    c:RegisterEffect(e2)   
    --Judgement Arrows!!(^_^)
     local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(Cirn9.clcon)
    e3:SetCost(Cirn9.clcost)
    e3:SetTarget(cm.cltg)
    e3:SetOperation(cm.clop)
    c:RegisterEffect(e3)   
    cm.ClimaxAct=e3
end
function cm.hltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xc99)
end
function cm.hlop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    c:AddCounter(0xc99,1)
    --extra material
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,3))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(cm.linkcon)
    e2:SetOperation(cm.linkop)
    e2:SetValue(SUMMON_TYPE_LINK)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e3:SetTargetRange(LOCATION_EXTRA,0)
    e3:SetTarget(cm.mattg)
    e3:SetLabelObject(e2)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp)
end
function cm.lmfilter(c,lc,tp)
    return c:IsCanBeLinkMaterial(lc) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and c:IsAbleToRemove(tp) 
        and c:IsSetCard(0xc99)
end
function cm.linkcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(cm.lmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c,tp)
        and Duel.GetFlagEffect(tp,m+1)==0 and Duel.GetLocationCountFromEx(tp)>0
end
function cm.linkop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.SelectMatchingCard(tp,cm.lmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c,tp)
    c:SetMaterial(mg)
    Duel.Remove(mg,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
    Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
function cm.mattg(e,c)
    return c:IsSetCard(0xc99) and c:IsType(TYPE_LINK) and c:IsLink(1)
end
function cm.mvfilter(c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(0xc99)
end

function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
    if chk==0 then return Duel.IsExistingTarget(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
    e:GetHandler():AddCounter(0xc99,1)
    Duel.SelectTarget(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
    local a1=tc:GetSequence()
    local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
    local nseq=math.log(s,2)
    Duel.MoveSequence(tc,nseq)
    local a2=tc:GetSequence()
    if a1~=a2 then
        if Cirn9.IsReLinkState(tc) then
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
            tc:AddCounter(0xc99,1)
        end
    end
end
function cm.tffilter(c)
    return c:IsSetCard(0xc99) and c:IsType(TYPE_MONSTER)
end
function cm.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.clop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local revue=Cirn9.Climax(e,tp,eg,ep,ev,re,r,rp)
    if revue==0 then return
    elseif revue==1 then Cirn9.RevueBgm(tp) end 
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_GRAVE,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(20100098)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e1:SetRange(LOCATION_ONFIELD)
        e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
        e1:SetTarget(Cirn9.linktg)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetCode(EFFECT_CHANGE_TYPE)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e3:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        tc:RegisterEffect(e3)
    end
end