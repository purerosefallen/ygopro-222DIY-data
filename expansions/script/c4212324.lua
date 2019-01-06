--新大地的炼金工作室
local m=4212324
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:SetUniqueOnField(1,0,4212324)
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_SPECIAL_SUMMON)
        .e("SetType",EFFECT_TYPE_ACTIVATE)
        .e("SetCode",EVENT_FREE_CHAIN)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return true end
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then 
                if Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
                    if g:GetCount()>0 then
                        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
                    end 
                end
            end end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        .e("SetCode",EVENT_DESTROYED)
        .e("SetRange",LOCATION_SZONE)
        .e("SetProperty",EFFECT_FLAG_DELAY)
        .e("SetCountLimit",m,1)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_HAND,0,1,nil,tp) end end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
            local te,ceg,cep,cev,cre,cr,crp
            local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
            if tc then 
                Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
                local fchain=cm.copyfilter(tc)
                if fchain then
                    te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
                else
                    te=tc:GetActivateEffect()
                end
                local op=te:GetOperation()
                if op then op(e,tp,eg,ep,ev,re,r,rp) end
            end end)
    .Return())
end
function cm.tffilter(c,tp)
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa25) and not c:IsForbidden() and not c:IsType(TYPE_FIELD) and c:CheckUniqueOnField(tp)
end
function cm.copyfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xa25) and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xa25) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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