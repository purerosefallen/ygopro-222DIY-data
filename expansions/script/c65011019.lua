--幽舞之玛格丽塔
function c65011019.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65011019.sprcon)
	e0:SetOperation(c65011019.sprop)
	c:RegisterEffect(e0)
	--spsum
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65011019)
	e1:SetCondition(c65011019.spdcon)
	e1:SetTarget(c65011019.spdtg)
	e1:SetOperation(c65011019.spdop)
	c:RegisterEffect(e1)
end
function c65011019.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65011019.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65011019.sprfilter2,1,c,tp,c,sc,lv)
end
function c65011019.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-2 and c:GetOriginalLevel()>0 and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65011019.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65011019.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65011019.sprfilter1,1,nil,tp,g,c)
end
function c65011019.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65011019.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65011019.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65011019.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c65011019.spdcon(e,t,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetSummonLocation(LOCATION_EXTRA)
end

function c65011019.filter(c,e,tp)
	local lv=c:GetLevel()
	return Duel.IsExistingMatchingCard(c65011019.spfilter,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp) and c:IsType(TYPE_TUNER)
end

function c65011019.spfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c65011019.spdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()~=tp and c65011019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65011019.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>=-1  and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c65011019.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
end
function c65011019.spdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<-1 then return end
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		if Duel.MoveSequence(c,nseq)~=0 then
			local lv=tc:GetLevel()
			local g=Duel.SelectMatchingCard(tp,c65011019.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
			local mc=g:GetFirst()
			Duel.SpecialSummon(mc,0,tp,tp,false,false,POS_FACEUP)
			Duel.NegateRelatedChain(mc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(0)
			mc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(0)
			mc:RegisterEffect(e2)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			mc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_DISABLE_EFFECT)
			e5:SetValue(RESET_TURN_SET)
			e5:SetReset(RESET_EVENT+0x1fe0000)
			mc:RegisterEffect(e5)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			mc:RegisterEffect(e3)
		end
	end
end