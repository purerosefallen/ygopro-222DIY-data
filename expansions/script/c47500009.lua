--舞者 姬塔
function c47500009.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --twin act
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500009,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCountLimit(1,47500009)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(c47500009.datg)
    e1:SetOperation(c47500009.daop)
    c:RegisterEffect(e1)   
    --summon with no tribute
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500009,3))
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SUMMON_PROC)
    e2:SetCondition(c47500009.ntcon)
    c:RegisterEffect(e2) 
    --super xyz
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e3:SetCountLimit(1)
    e3:SetTarget(c47500009.xyztg)
    e3:SetOperation(c47500009.xyzop)
    c:RegisterEffect(e3)
    --effect gain
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BE_MATERIAL)
    e4:SetCondition(c47500009.effcon)
    e4:SetOperation(c47500009.effop)
    c:RegisterEffect(e4)
    --code
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_CHANGE_CODE)
    e5:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
    e5:SetValue(47500000)
    c:RegisterEffect(e5)
end
c47500009.card_code_list={47500000}
function c47500009.dbfilter(c)
    return c:IsFaceup() and c:IsCode(47500000)
end
function c47500009.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47500009.dbfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47500009.dbfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47500009.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47500009.daop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_QUICK_F)
        e1:SetCode(EVENT_CHAINING)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCountLimit(1)
        e1:SetCondition(c47500009.ddcon)
        e1:SetTarget(c47500009.ddtg)
        e1:SetOperation(c47500009.ddop)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c47500009.ddcon(e,tp,eg,ep,ev,re,r,rp)
    return re:GetHandler()==e:GetHandler()
end
function c47500009.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local tg=re:GetTarget()
        local event=re:GetCode()
        if event==EVENT_CHAINING then return
           not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
        else         
           local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
           return not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0)
        end
        return re:GetHandler():IsRelateToEffect(re)
    end
    local event=re:GetCode()
    e:SetLabelObject(re)
    e:SetCategory(re:GetCategory())
    e:SetProperty(re:GetProperty())
    local tg=re:GetTarget()
    if event==EVENT_CHAINING then
       if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
    else
       local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
       if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
    end
end
function c47500009.ddop(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if not te then return end
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c47500009.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47500009.xyzfilter(c)
    return c:IsXyzSummonable(nil) and aux.IsCodeListed(c,47500000)
end
function c47500009.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500009.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47500009.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47500009.xyzfilter,tp,LOCATION_EXTRA,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=g:Select(tp,1,1,nil)
        Duel.XyzSummon(tp,tg:GetFirst(),nil)
    end
end
function c47500009.effcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_XYZ
end
function c47500009.effop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,47500009)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_F)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c47500009.ddcon)
    e1:SetTarget(c47500009.ddtg)
    e1:SetOperation(c47500009.ddop)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1)
end