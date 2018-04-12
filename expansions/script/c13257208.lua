--宇宙战争机器 巨核Mk-3
function c13257208.initial_effect(c)
	c:EnableCounterPermit(0x354)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(13257208,0))
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_PROC)
	e11:SetCondition(c13257208.otcon)
	e11:SetOperation(c13257208.otop)
	e11:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e11)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c13257208.ctcon)
	e1:SetOperation(c13257208.ctop)
	c:RegisterEffect(e1)
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c13257208.rmlimit)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	--deck equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257208,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c13257208.eqtg)
	e4:SetOperation(c13257208.eqop)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(c13257208.bgmop)
	c:RegisterEffect(e12)
	c:RegisterFlagEffect(13257200,0,0,0,3)
	eflist={"deck_equip",e4}
	c13257208[c]=eflist
	
end
function c13257208.otfilter(c)
	return c:IsSetCard(0x353) and c:IsType(TYPE_MONSTER) and (c:IsControler(tp) or c:IsFaceup())
end
function c13257208.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c13257208.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c13257208.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c13257208.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)
end
function c13257208.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp -- and bit.band(r,REASON_EFFECT)~=0
end
function c13257208.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(13257208)==0 then 
		c:RegisterFlagEffect(13257208,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1,ev)
	else
		local label=c:GetFlagEffectLabel(13257208)
		c:SetFlagEffectLabel(13257208,label+ev)
	end
	if c:GetFlagEffectLabel(13257208)>=2500 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_DISCARD+REASON_EFFECT)
		c:SetFlagEffectLabel(13257208,0)
	end
end
function c13257208.rmlimit(e,c,p)
	return c:IsLocation(LOCATION_ONFIELD)
end
function c13257208.eqfilter(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function c13257208.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c13257208.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c13257208.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c13257208.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c13257208.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257208,4))
end


