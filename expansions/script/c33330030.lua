--深界探窟者 黎明卿
function c33330030.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--xyzlimit
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	eb:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	eb:SetValue(c33330030.xyzval)
	c:RegisterEffect(eb)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33330030,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c33330030.destg)
	e5:SetOperation(c33330030.desop)
	c:RegisterEffect(e5)
	--special 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(33330030,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetTarget(c33330030.pentg)
	e6:SetOperation(c33330030.penop)
	c:RegisterEffect(e6)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330030,3))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33330030.lvcost)
	e1:SetTarget(c33330030.lvtg)
	e1:SetOperation(c33330030.lvop)
	c:RegisterEffect(e1)
	--zxczxcvzxvzxvzxvzxvzvxzxvzxv
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetOperation(c33330030.check)
	--c:RegisterEffect(e4)
	--self destroy
	local evb2=Effect.CreateEffect(c)
	evb2:SetDescription(aux.Stringid(33330030,1))
	evb2:SetCategory(CATEGORY_DESTROY)
	evb2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	evb2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	evb2:SetRange(LOCATION_PZONE)
	evb2:SetCountLimit(1)
	evb2:SetTarget(c33330030.destg2)
	evb2:SetOperation(c33330030.desop2)
	c:RegisterEffect(evb2)
	Duel.AddCustomActivityCounter(33330030,ACTIVITY_SPSUMMON,c33330030.counterfilter)
end
function c33330030.gfilter(c,g)
	return not g:IsContains(c)
end
function c33330030.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,c)
	local fid=c:GetFieldID()
	if cg:GetCount()<=0 then return end
	for tc in aux.Next(cg) do
		local rfid=tc:GetFieldID()
		if rfid>fid then
Debug.Message("111")
		   Duel.RaiseSingleEvent(c,EVENT_CUSTOM+33330030,e,0,0,0,0)
		end
	end
end
function c33330030.xyzval(e,c)
	if not c then return false end
	return not c:IsSetCard(0x556)
end
function c33330030.counterfilter(c)
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return true end
	return c:IsSetCard(0x556)
end
function c33330030.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33330030,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33330030.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c33330030.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if bit.band(sumtype,SUMMON_TYPE_XYZ)==0 then return false end
	return not c:IsSetCard(0x556)
end
function c33330030.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330030.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c33330030.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=8
end
function c33330030.lvop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c33330030.lvfilter,tp,LOCATION_MZONE,0,nil)
	if sg:GetCount()<=0 then return end
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
	end
end
function c33330030.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable(e) and Duel.GetTurnPlayer()==tp end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c33330030.desop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c33330030.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33330030.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c33330030.thfilter(c)
	return c:IsCode(33330030) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function c33330030.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function c33330030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330030.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c33330030.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_PZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_PZONE)
end
function c33330030.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c33330030.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33330030.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_PZONE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
