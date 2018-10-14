--奇迹的巧合-库洛伊
local m=4231009
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(m,0))
        .e("SetType",EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        .e("SetCode",EVENT_SPSUMMON_SUCCESS)
        .e("SetProperty",EFFECT_FLAG_DELAY)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return iCount(0,tp,m,1) and Duel.GetDecktopGroup(tp,3):FilterCount(function(c,e) return c:IsDestructable(e) end,nil,e)==3  end Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local g=Duel.GetDecktopGroup(tp,3)
            if Duel.Destroy(g,REASON_EFFECT)~=0 then
                local dmg = g:FilterCount(function(c) return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_DESTROY) and ((c:IsType(Equip) and c:IsType(TYPE_SPELL)) or (c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)))end,nil)*500
                Duel.Damage(1-tp,dmg,REASON_EFFECT)
            end end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetDescription",aux.Stringid(m,0))
        .e("SetType",EFFECT_TYPE_IGNITION)
        .e("SetRange",LOCATION_MZONE)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return iCount(0,tp,m,2) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_GRAVE,0,1,nil) end
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
            local g = Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
            Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local c=e:GetHandler()
            local tc=Duel.GetFirstTarget()
            if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
                local g = Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
                Duel.Equip(tp,tc,g) 
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetReset(EVENT_PHASE+PHASE_STANDBY)
        e2:SetCountLimit(1)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetLabelObject(tc)
        e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
            local tc=e:GetLabelObject()
            if tc:GetFlagEffect(m)~=0 then return true else e:Reset() return false end
        end)
        e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
            local tc=e:GetLabelObject()
            Duel.Destroy(tc,REASON_EFFECT) 
        end)
        Duel.RegisterEffect(e2,tp)
            end end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_SPSUMMON_CONDITION)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        .e("SetValue",function(e,se,sp,st) return e:GetHandler():GetLocation()~=LOCATION_EXTRA end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_FIELD)
        .e("SetCode",EFFECT_SPSUMMON_PROC)
        .e("SetProperty",EFFECT_FLAG_UNCOPYABLE)
        .e("SetRange",LOCATION_EXTRA)
        .e("SetCondition",function(e,c)
            if c==nil then return true end 
            local tp=c:GetControler()
            return Duel.GetMZoneCount(tp)>-2 and Duel.GetLocationCountFromEx(tp)>0
                and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp,c)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local g1=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local g2=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_SZONE,0,1,1,g1:GetFirst())
            g1:Merge(g2)
            Duel.SendtoGrave(g1,REASON_COST) end)
    .Return()).c("RegisterEffect",iFunc(c)
        .e("SetType",EFFECT_TYPE_SINGLE)
        .e("SetCode",EFFECT_FUSION_MATERIAL)
        .e("SetProperty",EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        .e("SetCondition",function(e,g,gc,chkfnf)
            if g==nil then return true end
            local tp=e:GetHandlerPlayer()
            local f1=cm.filter1
            local f2=cm.filter2
            local chkf=bit.band(chkfnf,0xff)
            local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
            if gc then
                if not gc:IsCanBeFusionMaterial(e:GetHandler(),true) then return false end
                return (f1(gc) and mg:IsExists(f2,1,gc))
                    or (f2(gc) and mg:IsExists(f1,1,gc)) end
            local g1=Group.CreateGroup() local g2=Group.CreateGroup() local fs=false
            local tc=mg:GetFirst()
            while tc do
                if f1(tc) then g1:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
                if f2(tc) then g2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
                tc=mg:GetNext()
            end
            if chkf~=PLAYER_NONE then
                return fs and g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
            else return g1:IsExists(aux.FConditionFilterF2,1,nil,g2) end end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            local f1=cm.filter1
            local f2=cm.filter2
            local chkf=bit.band(chkfnf,0xff)
            local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler(),true)
            if gc then
                local sg=Group.CreateGroup()
                if f1(gc) then sg:Merge(g:Filter(f2,gc)) end
                if f2(gc) then sg:Merge(g:Filter(f1,gc)) end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
                local g1=sg:Select(tp,1,1,nil)
                Duel.SetFusionMaterial(g1)
                return
            end
            local sg=g:Filter(aux.FConditionFilterF2c,nil,f1,f2)
            local g1=nil
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
            if chkf~=PLAYER_NONE then
                g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
            else g1=sg:Select(tp,1,1,nil) end
            local tc1=g1:GetFirst()
            sg:RemoveCard(tc1)
            local b1=f1(tc1)
            local b2=f2(tc1)
            if b1 and not b2 then sg:Remove(aux.FConditionFilterF2r,nil,f1,f2) end
            if b2 and not b1 then sg:Remove(aux.FConditionFilterF2r,nil,f2,f1) end
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
            local g2=sg:Select(tp,1,1,nil)
            g1:Merge(g2)
            Duel.SetFusionMaterial(g1) end)
    .Return())
end
function cm.spfilter1(c,tp)
    return cm.filter1(c) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial()
        and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_SZONE,0,1,nil)
end
function cm.spfilter2(c)
    return cm.filter2(c) and c:IsCanBeFusionMaterial(nil,true) and c:IsAbleToGraveAsCost() and c:IsFaceup() 
end
function cm.filter1(c)
    return c:IsRace(RACE_SPELLCASTER)
end
function cm.filter2(c)
    return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)
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