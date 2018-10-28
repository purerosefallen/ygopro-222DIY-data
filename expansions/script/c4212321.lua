--露露亚的工作室-露露亚
local m=4212321
local cm=_G["c"..m]
function cm.initial_effect(c)
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(4212321,0))
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        .e("SetProperty",EFFECT_FLAG_DELAY)
        .e("SetCode",EVENT_TO_HAND)
        .e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
            return not e:GetHandler():IsReason(REASON_DRAW) end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            local c=e:GetHandler()
            if chk==0 then return iCount(0,tp,m,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
                and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            if not c:IsRelateToEffect(e) then return end
            Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(4212321,1))
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_QUICK_O)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetRange",LOCATION_HAND)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)
            local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
            if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c4212321.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
            local g=Duel.SelectMatchingCard(tp,c4212321.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
            Duel.SendtoHand(g,nil,REASON_COST) end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return iCount(0,tp,m,2) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            if not c:IsRelateToEffect(e) then return end
            Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(4212321,2))
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_UPDATE_ATTACK)
        .e("SetProperty",EFFECT_FLAG_SINGLE_RANGE)
        .e("SetRange",LOCATION_MZONE)
        .e("SetCondition",function(e)
            local ph=Duel.GetCurrentPhase()
            if not (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) then return false end
            local a=Duel.GetAttacker()
            local d=Duel.GetAttackTarget()
            return a==e:GetHandler() and d~=nil and Duel.GetMatchingGroupCount(c4212321.mfilter,tp,LOCATION_SZONE,0,nil)>=3  end)
        .e("SetValue",c:GetAttack()*2)
    .Return())
end
function c4212321.cfilter(c,ft)
    return c:IsFaceup() and c:IsAbleToHandAsCost() and (ft>0 or c:GetSequence()<5)
end
function c4212321.mfilter(c) 
    return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function iCount(name,tp,m,id)
    return ((name=="get" or name=="set")
        and {(name=="get"
            and {tonumber(((Duel.GetFlagEffect(tp,m)==nil) and {0} or {Duel.GetFlagEffect(tp,m)})[1])} 
            or { Debug.Message("","请使用Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)") })[1]}
        or {(bit.band(iCount("get",tp,m,id),math.pow(2,id-1))==0 and {true} or {false})[1]})[1]
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end